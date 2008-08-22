Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbYHVUSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbYHVUSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbYHVURx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:17:53 -0400
Received: from blackbird.sr71.net ([64.146.134.44]:34227 "EHLO
	blackbird.sr71.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbYHVURw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:17:52 -0400
Subject: Re: [RFC v2][PATCH 3/9] x86 support for checkpoint/restart
From: Dave Hansen <dave@sr71.net>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <Pine.LNX.4.64.0808202304180.17436@takamine.ncl.cs.columbia.edu>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0808202304180.17436@takamine.ncl.cs.columbia.edu>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 13:17:50 -0700
Message-Id: <1219436270.20559.131.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 23:04 -0400, Oren Laadan wrote:+
> +#ifdef CONFIG_X86_64
> +
> +#error "CONFIG_X86_64 unsupported yet."

Well, I told you I'd write some Kconfig magic for you, but I can't since
I can't apply these patches. :)

You need this in a Kconfig file somewhere:

config CHECKPOINT_RESTART
	prompt "Good prompt"
	def_bool y
	depends on X86_32 && EXPERIMENTAL
	help
		Lots of fun help...

config SELECT_ALL_NAMESPACES
	prompt "Enable all kernel namespace support"
	selects IPC_NS NET_NS ...
	help
		This option will save you having to go track down
		all of the individual places that namespaces are
		supported in the kernel.

		If you don't turn this on, the restart porttion
		of checkpoint/restart gets a lots less reliable...	

probably in checkpoint/Kconfig.

Then, in all of the architectures' arch/*/Kconfig files, you need to:

source "checkpoint/Kconfig"

Then, the Makefile looks like this:

--- /dev/null   2008-04-22 10:49:52.000000000 -0700
+++ oren-cr.git-dave/checkpoint/Makefile        2008-08-22 12:30:53.000000000 -0700
@@ -0,0 +1 @@
+obj-$(CONFIG_CHECKPOINT_RESTART) += sys.o checkpoint.o restart.o

-- Dave


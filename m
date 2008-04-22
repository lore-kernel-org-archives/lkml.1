Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbYDVAQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbYDVAQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758451AbYDVAQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:16:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55058
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758132AbYDVAQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:16:17 -0400
Date: Mon, 21 Apr 2008 17:16:19 -0700 (PDT)
Message-Id: <20080421.171619.126408955.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080421232534.GT27459@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0804211608570.2779@woody.linux-foundation.org>
	<20080421231815.GS27459@ZenIV.linux.org.uk>
	<20080421232534.GT27459@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 22 Apr 2008 00:25:34 +0100

> On Tue, Apr 22, 2008 at 12:18:15AM +0100, Al Viro wrote:
> 
> > FWIW, two things I _really_ want dead and gone are
> > 	* timod (or full rewrite of that animal; current one is badly racy
> > and plays fast and loose with way too many place in VFS guts)
> > 	* altroot (use chroot, damnit, and bind whatever you need in there)
> 
> BTW, the part about altroot goes for other architectures too; it's badly
> broken and it's one hell of an obstacle to fs/namei.c work of any kind.
> 
> As absolute minimum we _must_ lose the "if we hadn't found what we wanted
> in that subtree, repeat lookup starting at real root"; that's causing
> nightmares in pathname resolution and there's no excuse whatsoever for
> that since we have bindings.

The only platforms defining a non-NOP __emul_prefix() after this
sparc changeset are:

1) IA-64 for PER_LINUX32 --> /emul/ia32-linux/
2) MIPS for riscos and IRIX compat support
3) ARM for ARM_BSD_EMUL --> "usr/gnemul/bsd", yikes no leading slash
   in that path!

I bet if we really tried we could get rid of these things.

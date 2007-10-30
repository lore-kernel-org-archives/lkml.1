Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXJ3AG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXJ3AG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXJ3AGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:06:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55320 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbXJ3AGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:06:19 -0400
Date: Tue, 30 Oct 2007 00:06:18 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 32bit builds on x86-64 host.
Message-ID: <20071030000618.GG8181@ftp.linux.org.uk>
References: <20071029233231.GI7793@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029233231.GI7793@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 07:32:31PM -0400, Dave Jones wrote:
> Before the arch merge, I frequently would test 32bit compiles
> by doing make ARCH=i386 {bzImage/modules/file.o}
> 
> Since commit 47572387d58a9584c60ebbbdee56fc92c627f16f
> how does one do this?

Same.  Top-level makefile kludges around that:

SRCARCH         := $(ARCH)

# for i386 and x86_64 we use SRCARCH equal to x86
SRCARCH := $(if $(filter x86_64 i386,$(SRCARCH)),x86,$(SRCARCH))

and then plays with both ARCH and SRCARCH.  Note
# If a arch/$(SRCARCH)/Kconfig.$(ARCH) file exist use it
ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/Kconfig.$(ARCH)),)
        Kconfig := arch/$(SRCARCH)/Kconfig.$(ARCH)
else
        Kconfig := arch/$(SRCARCH)/Kconfig
endif

in scripts/kconfig/Makefile, BTW - now we use arch/x86/Kconfig.i386 and
arch/x86/Kconfig.x86_64 as starting points for ARCH=i386 and ARCH=x86_64
resp.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbXCTMN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbXCTMN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXCTMN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:13:27 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45772 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbXCTMN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:13:26 -0400
Date: Tue, 20 Mar 2007 13:12:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, rmk@arm.linux.org.uk
Subject: Re: [PATCH] Complain about missing system calls.
Message-ID: <20070320121251.GB10240@uranus.ravnborg.org>
References: <1173394873.3461.510.camel@pmac.infradead.org> <20070308.161407.63995586.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308.161407.63995586.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 04:14:07PM -0800, David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Thu, 08 Mar 2007 23:01:13 +0000
> 
> > Most system calls seem to get added to i386 first. This patch
> > automatically generates a warning for any new system call which is
> > implemented on i386 but not the architecture currently being compiled.
> > On PowerPC at the moment, for example, it results in these warnings:
> > init/missing_syscalls.h:935:3: warning: #warning syscall sync_file_range not implemented
> > init/missing_syscalls.h:947:3: warning: #warning syscall getcpu not implemented
> > init/missing_syscalls.h:950:3: warning: #warning syscall epoll_pwait not implemented
> > 
> > Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> 
> David, thanks for this __incredibly__ __useful__ patch.  I kicked it
> around on sparc64 and found some more ignores to add, see below.
> 
> The vast majority of them vector to sys_ni_syscall in the i386 syscall
> table.
> 
> sys_ugetrlimit is only necessary if the platform started out
> using the non-SuS compliant sys_old_getrlimit()
> 
> The rest, like ioperm, iopl, modify_ldt, et al. are i386
> specific.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> --- a/init/missing_syscalls.c.ORIG	2007-03-08 16:11:00.000000000 -0800
> +++ b/init/missing_syscalls.c	2007-03-08 16:02:30.000000000 -0800
> @@ -18,6 +18,22 @@
>  #endif
>  
>  /* i386-specific or historical system calls */
> +#define __IGNORE_break

Could it make sense to keep this in arch specific header files?
So when we fiddle with ARM we do not impact SPARC etc.
And in this way ARCH specific changes are kept in ARCH specific files.

For the "Ignore historical" part this should be in a common file I think.

So in other words:

init/missing_syscalls.h	=> Contains common stuff and include:
include/asm/missing_syscalls.h => contains ARCH specific stuff.


	Sam

Return-Path: <linux-kernel-owner+w=401wt.eu-S1767473AbXCIUNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767473AbXCIUNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767474AbXCIUNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:13:20 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4311 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767473AbXCIUNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:13:19 -0500
Date: Fri, 9 Mar 2007 20:13:08 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sam@ravnborg.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Complain about missing system calls.
Message-ID: <20070309201308.GB8444@flint.arm.linux.org.uk>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	sam@ravnborg.org, linux-arch@vger.kernel.org
References: <1173394873.3461.510.camel@pmac.infradead.org> <p737itqbdnl.fsf@bingen.suse.de> <20070309163805.GV18564@lug-owl.de> <45F1B818.4090007@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F1B818.4090007@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 11:40:08AM -0800, H. Peter Anvin wrote:
> Jan-Benedict Glaw wrote:
> >
> >Not everybody has a simple indexed list of pointers :)  For example,
> >for vax-linux, we use a struct per syscall with the expected number of
> >on-stack longwords for the call.
> >
> >So if something "new" is coming up, please keep in mind that it should
> >be flexible enough to represent that. :)
> >
> 
> I discussed with Al Viro a while ago about using something like the 
> SYSCALLS.def file from klibc as the source format for the system calls. 
>  That would deal very flexibly with almost all kinds of stub generation.

Hopefully with this idea in place, we can spot new syscalls before
the final release of the kernel (maybe kautobuild can help there)
and fix any silly system call argument ordering which requires
different architectures to have different syscall prototypes (eg,
sys_arm_fadvise64_64 vs sys_fadvise64_64, sys_arm_sync_file_range vs
sys_sync_file_range).

Otherwise the SYSCALLS.def file will probably end up being full of
ifdefs.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

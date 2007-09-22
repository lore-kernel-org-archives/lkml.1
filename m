Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbXIVJac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbXIVJac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 05:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbXIVJaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 05:30:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37829 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbXIVJaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 05:30:20 -0400
Date: Sat, 22 Sep 2007 10:30:17 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: vapier@gentoo.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [32/45] x86_64: hide cond_syscall behind __KERNEL__
Message-ID: <20070922093017.GB27827@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <ak@suse.de>, vapier@gentoo.org, patches@x86-64.org,
	linux-kernel@vger.kernel.org
References: <200709211044.901175000@suse.de> <20070921204514.DF01414EFF@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921204514.DF01414EFF@wotan.suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:45:14PM +0200, Andi Kleen wrote:
> From: Mike Frysinger <vapier@gentoo.org>
> 
> This brings x86_64 into line with all other architectures by only defining
> cond_syscall() when __KERNEL__ is defined.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Andi Kleen <ak@suse.de>

> Index: linux/include/asm-x86_64/unistd.h
> ===================================================================
> --- linux.orig/include/asm-x86_64/unistd.h
> +++ linux/include/asm-x86_64/unistd.h
> @@ -676,6 +676,7 @@ asmlinkage long sys_rt_sigaction(int sig
>  #endif	/* __KERNEL__ */

This is the previous __KERNEL__ block.

>  #endif	/* __NO_STUBS */

And this  one shouldn't extent iver the declarations of sys_iopl
and sys_rt_sigactions I think.  If it should be there at all.

So please make this file at least semi-clean while you're at it instead
of much worse.

The __KERNEL__ block should also be extended over the various __ARCH_WANT_
definitions because they're not for userspace at all.


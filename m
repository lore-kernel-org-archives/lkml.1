Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbYHGHtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbYHGHtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 03:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYHGHtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 03:49:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53066 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbYHGHtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 03:49:21 -0400
Date: Thu, 7 Aug 2008 09:49:20 +0200
From: Pavel Machek <pavel@suse.cz>
To: Michael Davidson <md@google.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: prevent binaries from making system calls using the wrong syscall interface
Message-ID: <20080807074920.GC16610@atrey.karlin.mff.cuni.cz>
References: <20080807003459.37CC629624@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807003459.37CC629624@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Prevent binaries from making system calls using other than one
> of the "normal" system call interfaces for that binary type.
> 
> Currently there is nothing to prevent 64 bit binaries from
> attempting to make system calls using the 32 bit system call
> interfaces and vice versa.

I thought this was a feature?

> Index: linux-2.6.26.2/arch/x86/ia32/ia32entry.S
> ===================================================================
> --- linux-2.6.26.2.orig/arch/x86/ia32/ia32entry.S	2008-08-06 09:19:01.000000000 -0700
> +++ linux-2.6.26.2/arch/x86/ia32/ia32entry.S	2008-08-06 13:34:54.566992000 -0700
> @@ -123,6 +123,8 @@
>   	.quad 1b,ia32_badarg
>   	.previous	
>  	GET_THREAD_INFO(%r10)
> +	testl  $_TIF_IA32,threadinfo_flags(%r10)
> +	jz     ia32_bad_abi
>  	orl    $TS_COMPAT,threadinfo_status(%r10)
>  	testl  $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
>  	CFI_REMEMBER_STATE

...and slowing down all syscalls for this is certainly bad idea.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

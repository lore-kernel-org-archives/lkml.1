Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbXL2Wp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbXL2Wp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 17:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbXL2WpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 17:45:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39049 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbXL2WpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 17:45:13 -0500
Date: Sat, 29 Dec 2007 23:43:26 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on x86-64
Message-ID: <20071229234326.GA17807@ucw.cz>
References: <200712281353.37976.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712281353.37976.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Document the fact that __save_processor_state() has to save all CPU
> registers referred to by the kernel in case a different kernel is
> used to load and restore a hibernation image containing it. 


> Sigend-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/x86/kernel/suspend_64.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> Index: linux-2.6/arch/x86/kernel/suspend_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/suspend_64.c
> +++ linux-2.6/arch/x86/kernel/suspend_64.c
> @@ -19,6 +19,21 @@ extern const void __nosave_begin, __nosa
>  
>  struct saved_context saved_context;
>  
> +/**
> + *	__save_processor_state - save CPU registers before creating a
> + *		hibernation image and before restoring the memory state from it
> + *	@ctxt - structure to store the registers contents in
> + *
> + *	NOTE: If there is a CPU register the modification of which by the
> + *	boot kernel (ie. the kernel used for loading the hibernation image)
> + *	might affect the operations of the restored target kernel (ie. the one
> + *	saved in the hibernation image), then its contents must be saved by this
> + *	function.  In other words, if kernel A is hibernated and different
> + *	kernel B is used for loading the hibernation image into memory, the
> + *	kernel A's __save_processor_state() function must save all registers
> + *	needed by kernel A, so that it can operate correctly after the resume
> + *	regardless of what kernel B does in the meantime.
> + */

Maybe this warning should be appended to struct saved_context
definition? Reordering its fields (etc) would be bad news, too, and
documentation near data structures is easier to find...

Thanks,
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

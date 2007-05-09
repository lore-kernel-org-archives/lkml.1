Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbXEIRPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbXEIRPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbXEIRPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:15:04 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754784AbXEIRPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:15:01 -0400
Date: Wed, 9 May 2007 10:14:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070509101445.fa6b60cb.akpm@linux-foundation.org>
In-Reply-To: <200705091452.08092.rjw@sisk.pl>
References: <20070430102837.748238000@linutronix.de>
	<1178701183.3042.469.camel@localhost.localdomain>
	<200705091345.55207.rjw@sisk.pl>
	<200705091452.08092.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 14:52:07 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > Andrew, could you please apply the appended patch and see if that
> > helps (should apply to -mm2)?
> 
> Argh, sorry.  This needs yet another patch (sent for review to linux-pm) to
> be applied.  The following one is against -mm2:
> 
> ---
> NOTE: This is not a complete solution, because it removes the enabling of GPEs
> from the resume-during-hibernation code path entirely, which probbably is not a
> good idea in general.
> ---
>  kernel/power/disk.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linux-2.6.21-mm2/kernel/power/disk.c
> ===================================================================
> --- linux-2.6.21-mm2.orig/kernel/power/disk.c
> +++ linux-2.6.21-mm2/kernel/power/disk.c
> @@ -205,7 +205,6 @@ int hibernate(void)
>  
>  	if (in_suspend) {
>  		enable_nonboot_cpus();
> -		platform_finish();
>  		device_resume();
>  		resume_console();
>  		pr_debug("PM: writing image.\n");

It now hangs in a similar fashion in the device_resume() call.

If I back off Thomas's clockevents-fix-resume-logic-updated-version.patch
and include just the above patch the machine does suspend and resume
correctly.

I can delve further into the device_resume() hang if we think it would be
useful.  Maybe Linus's clock-stomping tracer can help here, if I can
remember how to use it.



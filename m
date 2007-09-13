Return-Path: <linux-kernel-owner+w=401wt.eu-S1763687AbXIMEuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763687AbXIMEuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 00:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXIMEt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 00:49:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51235 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140AbXIMEt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 00:49:57 -0400
Date: Wed, 12 Sep 2007 21:48:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: clockevents: fix resume logic
Message-Id: <20070912214821.7457e88c.akpm@linux-foundation.org>
In-Reply-To: <1189616262.3254.9.camel@chaos>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	<200709111323.56030.rjw@sisk.pl>
	<20070911042228.1ef690e0.akpm@linux-foundation.org>
	<200709111409.13796.rjw@sisk.pl>
	<20070911112531.80bac380.akpm@linux-foundation.org>
	<1189535883.5235.13.camel@chaos>
	<20070911114417.3f6e9e1b.akpm@linux-foundation.org>
	<1189540321.5235.21.camel@chaos>
	<1189547387.5235.69.camel@chaos>
	<20070912021627.5b85a75f.akpm@linux-foundation.org>
	<1189616262.3254.9.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 18:57:42 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> Does the test hack below fix the problem for nohz/highres enabled
> kernels ?
> 
> 	tglx
> 
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -382,6 +382,8 @@ static int tick_broadcast_set_event(ktime_t expires, int force)
>  
>  int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
>  {
> +	cpu_set(smp_processor_id(), tick_broadcast_oneshot_mask);
> +
>  	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
>  
>  	if(!cpus_empty(tick_broadcast_oneshot_mask))

yup

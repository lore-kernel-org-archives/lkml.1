Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZGUTsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZGUTsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZGUTsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:48:21 -0400
Received: from fifo99.com ([67.223.236.141]:39856 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbZGUTsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:48:21 -0400
Subject: Re: [RFC][patch 3/5] remove clocksource inline functions
From: Daniel Walker <dwalker@fifo99.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20090721192059.454927873@de.ibm.com>
References: <20090721191745.788551122@de.ibm.com>
	 <20090721192059.454927873@de.ibm.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 12:48:11 -0700
Message-Id: <1248205691.14209.773.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 21:17 +0200, Martin Schwidefsky wrote:
> plain text document attachment (clocksource-inline.diff)
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Remove clocksource_read, clocksource_enable and clocksource_disable
> inline functions. No functional change.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: john stultz <johnstul@us.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  kernel/time/clocksource.c |   18 ++++++++++++------
>  kernel/time/timekeeping.c |   13 ++++++-------
>  2 files changed, 18 insertions(+), 13 deletions(-)
> 
> Index: linux-2.6/kernel/time/clocksource.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/clocksource.c
> +++ linux-2.6/kernel/time/clocksource.c
> @@ -517,7 +517,7 @@ void clocksource_forward_now(void)
>  	cycle_t cycle_now, cycle_delta;
>  	s64 nsec;
>  
> -	cycle_now = clocksource_read(clock);
> +	cycle_now = clock->read(clock);

What the benefit of this? You get the same result either way. I think
it's actually less error prone (less confusing) using the inlines ..

Daniel


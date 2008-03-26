Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbYCZMoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbYCZMoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYCZMnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:43:55 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:33294 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbYCZMny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:43:54 -0400
Message-ID: <47EA4500.9090708@frugalware.org>
Date: Wed, 26 Mar 2008 13:43:44 +0100
From: Gabriel C <crazy@frugalware.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
References: <200803170018.52663.rjw@sisk.pl> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org> <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org> <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de> <47E50AF9.5070801@frugalware.org> <alpine.LFD.1.00.0803221441370.3781@apollo.tec.linutronix.de> <47E5221B.5040900@frugalware.org> <alpine.LFD.1.00.0803221730560.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803222113541.3781@apollo.tec.linutronix.de> <47E58B06.8020905@frugalware.org> <47E63851.7000702@frugalware.org> <47E6E85E.9030008@frugalware.org> <alpine.LFD.1.00.0803241038420.3781@apollo.tec.linutronix.de> <47E82C1F.7070304@frugalware.org> <alpine.LFD.1.00.0803250902310.3781@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803250902310.3781@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 24 Mar 2008, Gabriel C wrote:
>>> Hmm. Can you please apply the patch below. It add some more info and
>>> triggers the sysrq-q timer list printout when the watchdog
>>> triggers. That might us give some insight into this.
>> Sorry for the lag , I was out the whole day.
>>
>> Here is what I've found in dmesg ( the box was idling at that time , as said I was not around ):
>>
>> ...
>>
>> [34528.893366] Clocksource tsc unstable (delta = 4686697613 ns) E:34204592 J:34210723
> 
> Ok. The timer got delayed. It got delayed because it is initialized as
> a deferrable timer, which is obviously wrong. Sigh, I signed off on
> that commit myself without thinking about the consequences.
> 
> Can you please apply the patch below on top of the others?

Box is up for almost one day with that patch on top the other ones and everything is fine so far.


> revert: 1077f5a917b7c630231037826b344b2f7f5b903f
> 
> ---
>  kernel/time/clocksource.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/time/clocksource.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/clocksource.c
> +++ linux-2.6/kernel/time/clocksource.c
> @@ -176,7 +176,7 @@ static void clocksource_check_watchdog(s
>  			if (watchdog)
>  				del_timer(&watchdog_timer);
>  			watchdog = cs;
> -			init_timer_deferrable(&watchdog_timer);
> +			init_timer(&watchdog_timer);
>  			watchdog_timer.function = clocksource_watchdog;
>  
>  			/* Reset watchdog cycles */
> 
> 


Gabriel

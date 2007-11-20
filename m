Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbXKTJGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbXKTJGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbXKTJGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:06:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37939 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbXKTJGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:06:07 -0500
Date: Tue, 20 Nov 2007 10:05:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: nohz and strange sleep latencies
Message-ID: <20071120090555.GA21424@elte.hu>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120085704.GA19950@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > hpet-disable helps.. a bit. 200msec latencies are gone. (What is 
> > used for wakeups in this case?)
> > 
> > pavel@amd:~$ while true; do time sleep 0.01; done
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 22.96%CPU
> > 0.00user 0.00system 0.01 (0m0.018s) elapsed 11.05%CPU
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 15.54%CPU
> 
> could you run this while doing the sleep test:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> 
> and send us the output? (Enabling CONFIG_TIMER_STATS, 
> CONFIG_SCHED_DEBUG and CONFIG_SCHEDSTATS would maximize the amount of 
> information.)

another question: do you feel and see these timer latencies? If unsure 
you can do a timing test from a remote (known-good) box:

   while :; do time ssh testbox sleep 0.01; done

there'll be a fair bit of offset cost and noise, but these fluctuations 
should still be there and should be noticeable.

but i suspect the delays are "real", i.e. caused by timers not firing at 
the right moment and not by some GTOD anomaly. Once you send the debug 
data we might be able to tell more.

	Ingo

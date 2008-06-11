Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbYFKR4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbYFKR4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 13:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764153AbYFKRzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 13:55:54 -0400
Received: from mx2.compro.net ([216.54.166.4]:31629 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820AbYFKRzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:55:53 -0400
X-IronPort-AV: E=Sophos;i="4.27,625,1204520400"; 
   d="scan'208";a="2333598"
Message-ID: <48501159.4050908@compro.net>
Date: Wed, 11 Jun 2008 13:54:33 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
References: <200806102152.23286.solstice.dhiver@gmail.com>	<20080610131314.5f7069e6@infradead.org>	<484EE71A.40002@intel.com>	<alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>	<20080611063639.5e1eea5b@infradead.org>	<alpine.LNX.1.10.0806111552090.20733@fbirervta.pbzchgretzou.qr>	<20080611065816.6cff290d@infradead.org>	<Pine.LNX.4.61.0806111006560.23096@chaos.analogic.com>	<20080611083644.32afc823@infradead.org>	<4850046C.4070602@compro.net> <20080611104446.3b0ce2d9@infradead.org>
In-Reply-To: <20080611104446.3b0ce2d9@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 11 Jun 2008 12:59:24 -0400
> Mark Hounschell <markh@compro.net> wrote:
> 
>> Arjan van de Ven wrote:
>>> On Wed, 11 Jun 2008 10:14:50 -0400
>>> "linux-os (Dick Johnson)" <linux-os@analogic.com> wrote:
>>>
>>>> I use CPU frequency to scale the output of rdtsc when timing
>>>> routines being optimized.
>>> Ok this is broken in various really bad ways.
>>>
>>> 1) CPU frequency is very fluctuating, it changes in principle every
>>> millisecond or more
>> I'm curious. What do you mean by "in principle"? And why will it
>> change?
> 
> ondemand governor will change the cpu frequency dynamically all the
> time.
> the cpu itself has a dynamic range in which it operates (at least on
> cpus that support Intel Dynamic Acceleration technology, IDA)
> 

OK. If I am always using AMD Opteron/X64 class machines am I safe here
when no cpu freq scaling stuff is on and I'm pinned to a particular processor?

>>> 2) the rdtsc "frequency" is conceptually unrelated to cpu
>>> frequency. In fact, you'll be hard-pressed to buy a system today
>>> where this relationship works....
>>>
>> And what do you mean by "conceptually unrelated to cpu frequency"?
>> Is it not the clock freq that is driving the cpu and the freq at which
>> the tsc is incremented?
> 
> no it is not that... at all.
> the tsc comes from an entirely different clock, and on anything you can
> buy today from AMD or Intel (or the last year for that matter), it's
> fixed frequency (except in idle) irrespective of the frequency the CPU
> is operating at!
> it's a "time stamp counter" not a "cpu cycle counter". You can run
> instructions faster than the tsc increment or slower. Or sometimes at
> the same rate.
> Which it is depends on what cpufreq/ondemand are doing and how active
> IDA is.
> 

I was under the impression that it was the same clock on AMD Opteron and
newer processors.

So if all this is true how and why can the kernel use it but user land is wrong
for doing so?

Mark 


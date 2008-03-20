Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbYCTBkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbYCTBkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYCTBkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:40:05 -0400
Received: from mga05.intel.com ([192.55.52.89]:65227 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752300AbYCTBkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:40:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,527,1199692800"; 
   d="scan'208";a="536734981"
Subject: Re: VolanoMark performance improvements (was: Re: volanoMark 12%
	regression with 2.6.25-rc6)
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20080319134813.GA25197@elte.hu>
References: <1205831650.3215.569.camel@ymzhang>
	 <20080318195807.GA26887@elte.hu> <1205892420.3215.594.camel@ymzhang>
	 <20080319021555.GA15825@elte.hu> <1205896722.3215.624.camel@ymzhang>
	 <20080319032854.GA20793@elte.hu> <1205901807.3215.659.camel@ymzhang>
	 <20080319134813.GA25197@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Thu, 20 Mar 2008 09:35:46 +0800
Message-Id: <1205976946.14496.9.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-19 at 14:48 +0100, Ingo Molnar wrote:
> i just tried a handful of kernels with VolanoMark on an Intel quad-core 
> testbox,
How many physical processors does it have?

>  using java-1.6.0-openjdk-1.6.0.0-0.4.b06.fc9.
> 
> The result: v2.6.25 is the fastest ever Linux kernel in VolanoMark 
> testing, -rc7-to-be is ~41% faster than v2.6.24.2, and ~59% faster than 
> v2.6.21, in this Java benchmark:
Did you set /proc/sys/kernel/sched_compat_yield=1 before testing? If not,
pls. configure it.

> 
> v2.6.25-rc7-to-be:
> 
>   Average throughput = 145613 messages per second
>   Average throughput = 142569 messages per second
>   Average throughput = 144963 messages per second
>   Average throughput = 144998 messages per second
>   Average throughput = 144213 messages per second
>   Average throughput = 144491 messages per second
> 
> v2.6.24.2:
> 
>   Average throughput = 101351 messages per second
>   Average throughput =  99247 messages per second
>   Average throughput = 101155 messages per second
>   Average throughput = 103905 messages per second
>   Average throughput =  98345 messages per second
>   Average throughput = 102775 messages per second
> 
> v2.6.21:
> 
>   Average throughput =  87630 messages per second
>   Average throughput =  91366 messages per second
>   Average throughput =  91317 messages per second
>   Average throughput =  91317 messages per second
>   Average throughput =  91359 messages per second
>   Average throughput =  92116 messages per second
> 
> these numbers are totally reproducible when running them over a long 
> time, i only included 6 runs for brevity. (A sidenote: the 
> /proc/sys/kernel/compat_sched_yield switch of 0 or 1 has no effect on 
> the .25-rc7 results, and it degraded the .24 results by about 35% so i 
> kept it off there.)
> 
> so i can see no 12% regression at all - but i have not tried all the 
> zillions of older, binary-only Java distributions.
> 
> So, to make the tests comparable, and to make some progress on this 
> matter, could you please try java-1.6.0-openjdk - what kind of 
> VolanoMark numbers do you get with it?
On my stoakley (2 quad-core processors, 2.66GHz), with jrockit-R27.3.1-jre1.5.0_11.x86_64:
v2.6.22:363062
v2.6.24:390248
v2.6.25-rc3:210276
v2.6.25-rc4:379704
v2.6.25-rc5:377723
v2.6.25-rc6:322864
The regression is reproducible.


On another tigerton(4 quad-core processors, 2.93GHz):
v2.6.25-rc5:577752
v2.6.25-rc6:579936
So there is no regression on tigerton.


>  If you still see a regression 
> with an open Java package too then could you please send me the .config 
> of your test-kernel? 
I will try openjdk.

-yanmin



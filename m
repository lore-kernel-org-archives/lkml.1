Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZDVDIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZDVDIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 23:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZDVDIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 23:08:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37738 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZDVDIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 23:08:13 -0400
Message-ID: <49EE89EF.1000707@ti.com>
Date: Tue, 21 Apr 2009 22:07:27 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep for
 more than 2.15 seconds
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com> <1240358715.6080.42.camel@localhost>
In-Reply-To: <1240358715.6080.42.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> One other minor comment nit, if we're really meaning that max_delta_ns
> is a 64bit value, should we not just be using s64 and be explicit
> instead of converting longs to long longs?

Thanks for the feedback. I am in two minds about this. I agree and I 
would prefer to use s64/u64 as this is explicit with regard to the size 
of the data type. However, for right or wrong I ended up with long long 
because...

a). The function clockevent_delta2ns() uses LONG_MAX (or in my 
suggestion LLONG_MAX) as the upper limit. LONG_MAX and LLONG_MAX are 
defined as a long and long long respectively.

#define LONG_MAX        ((long)(~0UL>>1))
#define LLONG_MAX       ((long long)(~0ULL>>1))

b). There are a couple prints in the kernel for display max_delta_ns and 
min_delta_ns. The prints use %lu and %llu to indicate long and long long 
types respectively.

So to avoid using casts or possibly a type mismatch for some 
architecture that I may have overlooked I kept it as long long. So this 
assumes that long long will be a 64-bit type which I don't like. 
However, this would not cause any compilation issues even if long long 
turned out to be 32-bits or 128-bits (if this is even possible). We 
could use u64 and cast where necessary to be safe/correct if this is 
preferred.

Cheers
Jon

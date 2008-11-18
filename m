Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbYKRQr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbYKRQr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYKRQrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:47:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:24883 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbYKRQrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:47:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,626,1220252400"; 
   d="scan'208";a="464515476"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Joe Korty <joe.korty@ccur.com>
CC: H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 18 Nov 2008 08:47:35 -0800
Subject: RE: [PATCH] x86: Support always running TSC on Intel CPUs
Thread-Topic: [PATCH] x86: Support always running TSC on Intel CPUs
Thread-Index: AclJl5BcekRub77oTbOSyx162kZK5AABCyBg
Message-ID: <7E82351C108FA840AB1866AC776AEC464291BB4F@orsmsx505.amr.corp.intel.com>
References: <20081118001137.GA12350@linux-os.sc.intel.com>
 <20081118080952.GE17838@elte.hu> <20081118145540.GA32082@tsunami.ccur.com>
 <20081118160542.GC8088@elte.hu>
In-Reply-To: <20081118160542.GC8088@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Tuesday, November 18, 2008 8:06 AM
>To: Joe Korty
>Cc: Pallipadi, Venkatesh; H Peter Anvin; Thomas Gleixner; linux-kernel
>Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
>
>
>* Joe Korty <joe.korty@ccur.com> wrote:
>
>> On Tue, Nov 18, 2008 at 09:09:52AM +0100, Ingo Molnar wrote:
>> >
>> > * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>> >
>> > > +        if (c->x86_power & (1 << 8)) {
>> > >                  set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
>> > > +                set_cpu_cap(c, X86_FEATURE_NOSTOP_TSC);
>> > > +        }
>> >
>> > hm, the naming is a bit confusing. We now have 3 variants:
>> >
>> >   X86_FEATURE_TSC
>> >   X86_FEATURE_CONSTANT_TSC
>> >   X86_FEATURE_NOSTOP_TSC
>> >
>> > NOSTOP_TSC is basically what CONSTANT_TSC should have been
>to begin
>> > with ;-)
>> >
>> > i'd suggest to rename it to this:
>> >
>> >   X86_FEATURE_TSC
>> >   X86_FEATURE_CONSTANT_FREQ_TSC
>> >   X86_FEATURE_STABLE_TSC
>> >
>> > ... with CONSTANT_FREQ_TSC not having any real role in the
>long run.
>> > (it's similarly problematic to a completely unstable TSC)
>> >
>> > does this sound ok?
>>
>>
>> To me, the new naming has the same head-scratching potential
>> as the old....
>>
>> How about:
>>
>>      X86_FEATURE_TSC
>>      X86_FEATURE_STABLE_TSC_OBSOLETE
>>      X86_FEATURE_STABLE_TSC
>
>the _honest_ naming would be:
>
>       X86_FEATURE_TSC
>       X86_FEATURE_STABLE_TSC_BUT_NOT_ALWAYS
>       X86_FEATURE_STABLE_TSC
>
>;-)
>
>what's head-scratching about X86_FEATURE_CONSTANT_FREQ_TSC? It's a
>limited TSC variant: it follows a reference frequency that does not
>change with cpufreq changes, but it can stop at a whim in C states. So
>it's not "stable" nor really "constant" in the everyday sense.
>

I don't like STABLE_TSC_OBSOLETE as it does not say anything
descriptive about what it means and people have to look at the code
to find out.

My original intention was to split this into two features
- P/T state invariant TSC which counts at constant rate
- C-state invariant TSC that never stops
Some CPUs will have only first feature. Others may have both.

But, I agree it is confusing.

How about?
X86_FEATURE_FIXEDFREQ_MAYSTOP_TSC
X86_FEATURE_ALWAYS_RUNNING_TSC

Thanks,
Venki

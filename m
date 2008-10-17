Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbYJQUvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbYJQUvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYJQUvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:51:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:56983 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbYJQUvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:51:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,434,1220252400"; 
   d="scan'208";a="628494913"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 17 Oct 2008 13:51:42 -0700
Subject: RE: [PATCH] x86: Add clflush before monitor for Intel 7400 series
Thread-Topic: [PATCH] x86: Add clflush before monitor for Intel 7400 series
Thread-Index: AckwlNXPcESWamTqSdCjUWMH4EAmXgAAwqTg
Message-ID: <7E82351C108FA840AB1866AC776AEC4637B799FB@orsmsx505.amr.corp.intel.com>
References: <20081007210056.GA5802@linux-os.sc.intel.com>
 <48EBCFF8.6050500@zytor.com> <20081007214920.GA17439@linux-os.sc.intel.com>
 <48EBEA97.9020404@zytor.com>
 <7E82351C108FA840AB1866AC776AEC4637B798D6@orsmsx505.amr.corp.intel.com>
 <48F8F1DB.9030202@zytor.com>
In-Reply-To: <48F8F1DB.9030202@zytor.com>
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
>From: H. Peter Anvin [mailto:hpa@zytor.com]
>Sent: Friday, October 17, 2008 1:13 PM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Thomas Gleixner; linux-kernel
>Subject: Re: [PATCH] x86: Add clflush before monitor for Intel
>7400 series
>
>Pallipadi, Venkatesh wrote:
>>
>> hpa,
>>
>> Do you still have reservations about this being expensive.
>> Note that this is only done when a CPU is about to go idle and
>> The cost of clflush itself will be minimal compared to idle
>> entry + idle exit latency.
>>
>
>I guess I'm a bit confused about the tradeoff of CLFLUSH versus simply
>disabling MWAIT.  This is a relatively recent processor and so
>optimizing matters (if this was a P4 I would be more worried about what
>has least impact on the kernel as a whole.)

As of now this is only for a limited models of CPUs (MP CPUs)
and not a norm. It is a errata on this CPU and not
something that is going to become architectural.

>Entry and exit latency do matter (specifically, exit latency
>matters for
>longer waits and the combined entry+exit latency matters for
>short waits.)

Agreed. In this case the overhead of clflush is very low (~30 cycles)
and C1 entry+exit latency will be of the order of few hundreds of cycles for
fastest wakeup.

>On the other hand, perhaps what we need to do is to get the fix in and
>worry about performance later.
>
>        -hpa

Thanks,
Venki

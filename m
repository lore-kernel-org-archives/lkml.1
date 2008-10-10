Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbYJJQEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbYJJQEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760979AbYJJQE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:04:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:24547 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760948AbYJJQE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:04:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,390,1220252400"; 
   d="scan'208";a="449577630"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 10 Oct 2008 09:01:32 -0700
Subject: RE: [PATCH] Typo in x86 apic.c with DIVISOR setup
Thread-Topic: [PATCH] Typo in x86 apic.c with DIVISOR setup
Thread-Index: Ackqmow7CyBsQU8GT9i1fIr+LsgoFwAVi0gw
Message-ID: <7E82351C108FA840AB1866AC776AEC4637823667@orsmsx505.amr.corp.intel.com>
References: <20081010002203.GA23238@linux-os.sc.intel.com>
	 <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com>
	 <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com>
 <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com>
In-Reply-To: <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com>
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
>From: Cyrill Gorcunov [mailto:gorcunov@gmail.com]
>Sent: Thursday, October 09, 2008 10:39 PM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Thomas Gleixner; H. Peter Anvin; linux-kernel
>Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
>
>
>But here is not the same
>
>       apic_write(APIC_TDCR,
>               (tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
>-               APIC_TDR_DIV_16);
>+               APIC_TDR_DIV);
>
>On x86_64 it will be 1 now but we've used 16 for a long time in purpose
>to slowdown processor's bus CLKs from APIC point of view. So I
>don't think
>it's good idea to change it now. If we start using divisor 1
>today -- it would
>work for some time 'till processor bus raised to the some speed when
>we'll get counter underflow before calibration finished.
>

I understand that using 1 instead of 16 makes APIC timer count 16 times faster.
I did that change as I thought that was the intention of making APIC_DIVISOR as 1.
Otherwise, there is no real impact of APIC_DIVISOR #define from being there. It
Is just changing the value of calibration_result across 32 bit and 64 bit kernels.

For example, "host bus clock speed" message will print different values across
32 bit and 64 bit kernels on the same system, if we just make APIC_DIVISOR
16 for 32 bit and 1 for 64 bit kernel.


Thanks,
Venki

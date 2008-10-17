Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYJQUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYJQUF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbYJQUFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:05:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:13482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbYJQUFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:05:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,434,1220252400"; 
   d="scan'208";a="349452657"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 17 Oct 2008 13:05:00 -0700
Subject: RE: [PATCH] x86: Add clflush before monitor for Intel 7400 series
Thread-Topic: [PATCH] x86: Add clflush before monitor for Intel 7400 series
Thread-Index: Acko0O8yk+NFLk9LRqS2jkEgx9c8PQHwjUww
Message-ID: <7E82351C108FA840AB1866AC776AEC4637B798D6@orsmsx505.amr.corp.intel.com>
References: <20081007210056.GA5802@linux-os.sc.intel.com>
 <48EBCFF8.6050500@zytor.com> <20081007214920.GA17439@linux-os.sc.intel.com>
 <48EBEA97.9020404@zytor.com>
In-Reply-To: <48EBEA97.9020404@zytor.com>
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
>Sent: Tuesday, October 07, 2008 4:03 PM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Thomas Gleixner; linux-kernel
>Subject: Re: [PATCH] x86: Add clflush before monitor for Intel
>7400 series
>
>Venki Pallipadi wrote:
>
>> Yes. Other alternative is to disable mwaits altogether on
>these CPUs. I can
>> send a patch to do that. But, the patch will be somewhat
>more complicated
>> as kernel advertises the MWAIT capability to firmware with a
>ACPI _PDC method
>> and BIOS has to then give IO port based C2 for us to use in
>such case.
>> Avoiding mwait just for C1 is easy though.
>
>It would be my weak preference, although I'm willing to be convinced
>that mwait is worth the power savings even with the workaround.
>
>        -hpa

hpa,

Do you still have reservations about this being expensive.
Note that this is only done when a CPU is about to go idle and
The cost of clflush itself will be minimal compared to idle
entry + idle exit latency.

Thanks,
Venki

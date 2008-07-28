Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbYG1WGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbYG1WGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbYG1WGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:06:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:52370 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbYG1WGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:06:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,267,1215414000"; 
   d="scan'208";a="26018936"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Len Brown <lenb@kernel.org>
Date: Mon, 28 Jul 2008 15:05:09 -0700
Subject: RE: [PATCH] ACPI/CPUIDLE: prevent setting pm_idle to NULL
Thread-Topic: [PATCH] ACPI/CPUIDLE: prevent setting pm_idle to NULL
Thread-Index: Acjw66QKilKa+tcNT86P7G6IdQPeJAAEdH1g
Message-ID: <7E82351C108FA840AB1866AC776AEC4608E237D5@orsmsx505.amr.corp.intel.com>
References: <alpine.LFD.1.10.0807272343480.574@apollo.tec.linutronix.de>
 <20080728174644.GC30344@one.firstfloor.org>
 <alpine.LFD.1.10.0807282107500.14925@apollo.tec.linutronix.de>
 <20080728195324.GE30344@one.firstfloor.org>
In-Reply-To: <20080728195324.GE30344@one.firstfloor.org>
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
>From: Andi Kleen [mailto:andi@firstfloor.org]
>Sent: Monday, July 28, 2008 12:53 PM
>To: Thomas Gleixner
>Cc: Andi Kleen; Linus Torvalds; Andrew Morton; LKML; Ingo
>Molnar; Dhaval Giani; Pallipadi, Venkatesh; Len Brown
>Subject: Re: [PATCH] ACPI/CPUIDLE: prevent setting pm_idle to NULL
>
>> The problem here is that the acpi/cpuidle code can be in a
>state where
>> the _save/old variables _ARE_ NULL because they had not been
>> initialized with the original pm_idle before the module is removed or
>> the cst state changes. So all we have to do is to prevent pm_idle to
>> be set to NULL.
>
>It still seems wrong to me to fall back to the cpuidle idle function
>instead of the earlier idle function just because cpuidle was loaded
>in a weird way.
>

CPUIDLE code does not have any problem here, as it always saves the
pm_idle from initcall, which should be set to right idle, default or mwait.
It is just a safety check getting added.

Real problem reported here is in acpi processor_idle without CPUIDLE, and
in a case where there are no real ACPI C-states on the platform,
it was ending up marking pm_idle = NULL at run time (cpu offline/online path),
as there is no saved idle pointer.

Thanks,
Venki

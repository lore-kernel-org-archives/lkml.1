Return-Path: <linux-kernel-owner+w=401wt.eu-S1761927AbYJJQM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761927AbYJJQM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761019AbYJJQMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:12:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:11840 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761014AbYJJQMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:12:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,390,1220252400"; 
   d="scan'208";a="346437485"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
CC: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 10 Oct 2008 09:11:06 -0700
Subject: RE: [PATCH] x86: apic - unify APIC_DIVISOR
Thread-Topic: [PATCH] x86: apic - unify APIC_DIVISOR
Thread-Index: Ackq6S209DKmemvUR/e2FM9PSv8UkAACGYNQ
Message-ID: <7E82351C108FA840AB1866AC776AEC46378236B8@orsmsx505.amr.corp.intel.com>
References: <20081010150017.GD7328@localhost>
In-Reply-To: <20081010150017.GD7328@localhost>
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
>Sent: Friday, October 10, 2008 8:00 AM
>To: Ingo Molnar; Maciej W. Rozycki
>Cc: LKML; Pallipadi, Venkatesh
>Subject: [PATCH] x86: apic - unify APIC_DIVISOR
>
>Use APIC_DIVISOR being set to 16 for both 32/64bit
>mode. To escape APIC timer underflow during calibration
>set it to the maximum possible value.
>
>Also typo error (CONFG instead of proper CONFIG) fixed.
>The error was catched by Venkatesh Pallipadi, thanks a lot Venkatesh!
>See details on http://lkml.org/lkml/2008/10/9/425
>
>Reported-by: Venkatesh Pallipad <venkatesh.pallipadi@intel.com>
>Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>---
>
>Index: linux-2.6.git/arch/x86/kernel/apic.c
>===================================================================
>--- linux-2.6.git.orig/arch/x86/kernel/apic.c   2008-09-26
>20:43:47.000000000 +0400
>+++ linux-2.6.git/arch/x86/kernel/apic.c        2008-10-10
>16:37:26.000000000 +0400
>@@ -332,11 +332,7 @@ int lapic_get_maxlvt(void)
>  */
>
> /* Clock divisor */
>-#ifdef CONFG_X86_64
>-#define APIC_DIVISOR 1
>-#else
> #define APIC_DIVISOR 16
>-#endif
>
> /*
>  * This function sets up the local APIC timer, with a timeout of
>@@ -592,10 +588,10 @@ static int __init calibrate_APIC_clock(v
>        global_clock_event->event_handler = lapic_cal_handler;
>
>        /*
>-        * Setup the APIC counter to 1e9. There is no way the lapic
>+        * Setup the APIC counter to maximum. There is no way the lapic
>         * can underflow in the 100ms detection time frame
>         */
>-       __setup_APIC_LVTT(1000000000, 0, 0);
>+       __setup_APIC_LVTT(0xffffffff, 0, 0);
>
>        /* Let the interrupts run */
>        local_irq_enable();
>

Agree with the APIC_DIVISOR part.

But, not sure why/how the second change is related to this APIC_DIVISOR being 16.
Also, another nit. Technically we are not setting the "APIC counter to maximum"
as we do divide by 16 before programming initial count register in __setup_APIC_LVTT().

Thanks,
Venki

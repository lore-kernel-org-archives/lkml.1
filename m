Return-Path: <linux-kernel-owner+w=401wt.eu-S1762905AbYJJRRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762905AbYJJRRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759553AbYJJRQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:16:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:51563 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbYJJRQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:16:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qE7bhWj777dOwZJkZl/RVLbINEKp5pzulJeAT5dT26aAx12U3l9OCoe0Fk1mn2Yr6h
         zZrklNKqLmsAbPNy783s1LqYtIyRbhFxMvdXH8CppiSedX0rOZYWOgJ/EE2j3GwXfBcp
         do3NKmYs7GT5exa7hMhNHHj/2fLfoTpb4mh34=
Date: Fri, 10 Oct 2008 21:16:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: apic - unify APIC_DIVISOR
Message-ID: <20081010171645.GI7328@localhost>
References: <20081010150017.GD7328@localhost> <7E82351C108FA840AB1866AC776AEC46378236B8@orsmsx505.amr.corp.intel.com> <20081010163101.GG7328@localhost> <7E82351C108FA840AB1866AC776AEC46378238AE@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E82351C108FA840AB1866AC776AEC46378238AE@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pallipadi, Venkatesh - Fri, Oct 10, 2008 at 10:07:38AM -0700]
| 
| 
| >-----Original Message-----
| >From: Cyrill Gorcunov [mailto:gorcunov@gmail.com]
| >Sent: Friday, October 10, 2008 9:31 AM
| >To: Pallipadi, Venkatesh
| >Cc: Ingo Molnar; Maciej W. Rozycki; LKML
| >Subject: Re: [PATCH] x86: apic - unify APIC_DIVISOR
| >
| >[Pallipadi, Venkatesh - Fri, Oct 10, 2008 at 09:11:06AM -0700]
| >|
| >|
| >| >-----Original Message-----
| >| >From: Cyrill Gorcunov [mailto:gorcunov@gmail.com]
| >| >Sent: Friday, October 10, 2008 8:00 AM
| >| >To: Ingo Molnar; Maciej W. Rozycki
| >| >Cc: LKML; Pallipadi, Venkatesh
| >| >Subject: [PATCH] x86: apic - unify APIC_DIVISOR
| >| >
| >| >Use APIC_DIVISOR being set to 16 for both 32/64bit
| >| >mode. To escape APIC timer underflow during calibration
| >| >set it to the maximum possible value.
| >| >
| >| >Also typo error (CONFG instead of proper CONFIG) fixed.
| >| >The error was catched by Venkatesh Pallipadi, thanks a lot
| >Venkatesh!
| >| >See details on http://lkml.org/lkml/2008/10/9/425
| >| >
| >| >Reported-by: Venkatesh Pallipad <venkatesh.pallipadi@intel.com>
| >| >Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| >| >---
| >| >
| >| >Index: linux-2.6.git/arch/x86/kernel/apic.c
| >| >===================================================================
| >| >--- linux-2.6.git.orig/arch/x86/kernel/apic.c   2008-09-26
| >| >20:43:47.000000000 +0400
| >| >+++ linux-2.6.git/arch/x86/kernel/apic.c        2008-10-10
| >| >16:37:26.000000000 +0400
| >| >@@ -332,11 +332,7 @@ int lapic_get_maxlvt(void)
| >| >  */
| >| >
| >| > /* Clock divisor */
| >| >-#ifdef CONFG_X86_64
| >| >-#define APIC_DIVISOR 1
| >| >-#else
| >| > #define APIC_DIVISOR 16
| >| >-#endif
| >| >
| >| > /*
| >| >  * This function sets up the local APIC timer, with a timeout of
| >| >@@ -592,10 +588,10 @@ static int __init calibrate_APIC_clock(v
| >| >        global_clock_event->event_handler = lapic_cal_handler;
| >| >
| >| >        /*
| >| >-        * Setup the APIC counter to 1e9. There is no way the lapic
| >| >+        * Setup the APIC counter to maximum. There is no
| >way the lapic
| >| >         * can underflow in the 100ms detection time frame
| >| >         */
| >| >-       __setup_APIC_LVTT(1000000000, 0, 0);
| >| >+       __setup_APIC_LVTT(0xffffffff, 0, 0);
| >| >
| >| >        /* Let the interrupts run */
| >| >        local_irq_enable();
| >| >
| >|
| >| Agree with the APIC_DIVISOR part.
| >|
| >| But, not sure why/how the second change is related to this
| >APIC_DIVISOR being 16.
| >| Also, another nit. Technically we are not setting the "APIC
| >counter to maximum"
| >| as we do divide by 16 before programming initial count
| >register in __setup_APIC_LVTT().
| >|
| >| Thanks,
| >| Venki
| >|
| >
| >From __setup_APIC_LVTT(0xffffffff, 0, 0) caller point of view we do
| >set maximum possible value. How you could make it bigger?
| >(without additional changes _inside_ __setup_APIC_LVTT itself).
| 
| 
| The basic question is why are we making this change now? Is the old value
| breaking some system today? Or Is it not to break some future system with
| very high bus clock freq? If we are doing it to future proof things,
| we should be making more changes inside __setup_APIC_LVTT and make
| this maximum possible value..
| 
| >Actually I wouldn't mind if you fix the comment if you don't like
| >this 'correlation' btw CLKs divisor and APIC_DIVISOR. No problem :)
| 
| No problem. I can send a separate patch to change this calibration
| count to maximum once I understand why exactly we are doing it now :).
| 
| Thanks,
| Venki
|

We do unify apic code I would say.
 
		- Cyrill -

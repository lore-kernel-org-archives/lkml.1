Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYKFH2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYKFH2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYKFH2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:28:23 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:23335 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbYKFH2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:28:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HFJbPH0Xh5I2tp5Y3zCvBBQ9cHxYq0/j+PLEy0W9b78W9pCO9+xSdjaF76YKj4Ictw
         cgkoaCJWOtxY/u1ibjGrYfld6J4R1CQvvY/cw12PCLZrsWmd3IB3M4J/co9qEO8BDWWy
         iFMM3URyiCucgj3CQ3Y0pcMQmKJgWVBAeJJMI=
Message-ID: <86802c440811052328l350698caxfc12290a75e613cc@mail.gmail.com>
Date: Wed, 5 Nov 2008 23:28:21 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ben Hutchings" <bhutchings@solarflare.com>
In-Reply-To: <86802c440811052310o1cd9d75bma489d9ab66ed514a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4910C845.4060909@kernel.org> <20081106062608.GC6384@elte.hu>
	 <86802c440811052242taefec24ndf661b1c65ca457e@mail.gmail.com>
	 <4912943C.2090801@zytor.com>
	 <86802c440811052300y279bd289t74b437a2053b97d1@mail.gmail.com>
	 <491296B2.6090700@zytor.com>
	 <86802c440811052310o1cd9d75bma489d9ab66ed514a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 11:10 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Nov 5, 2008 at 11:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Yinghai Lu wrote:
>>>
>>> On Wed, Nov 5, 2008 at 10:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>>
>>>> Yinghai Lu wrote:
>>>>>>
>>>>>> Clean-up sidenote: i think we can now remove the VISWS #ifdef portion
>>>>>> for good? Mind sending a patch for that too?
>>>>>
>>>>> could remove CONFIG_PARAVIRT too.. Jeremy?
>>>>>
>>>> This seems like a bad idea, especially for the embedded guys.
>>>
>>> make one CONFIG_NR_IRQS for them before working out one dyna_array is
>>> get merged?
>>>
>>
>> Ah, sorry... I missed the context and thought you meant removing
>> CONFIG_PARAVIRT in general.
>
> I mean make NR_IRQS bigger like IO_APIC is set when CONFIG_PARAVIRT is set.
>
like

diff --git a/arch/x86/include/asm/irq_vectors.h
b/arch/x86/include/asm/irq_vectors.h
index 503aadc..0005adb 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -101,18 +101,18 @@
 #define LAST_VM86_IRQ          15
 #define invalid_vm86_irq(irq)  ((irq) < 3 || (irq) > 15)

-#if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_PARAVIRT) &&
!defined(CONFIG_X86_VISWS) && !defined(CONFIG_X86_VOYAGER)
+#if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_X86_VOYAGER)
 # if NR_CPUS < MAX_IO_APICS
 #  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
 # else
 #  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
 # endif

-#elif defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS) ||
defined(CONFIG_X86_VOYAGER)
+#elif defined(CONFIG_X86_VOYAGER)

 # define NR_IRQS               224

-#else /* IO_APIC || PARAVIRT */
+#else /* IO_APIC || VOYAGER */

 # define NR_IRQS               16

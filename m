Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYKFHhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYKFHhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYKFHhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:37:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:51465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbYKFHhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:37:39 -0500
Message-ID: <49129E90.7050004@kernel.org>
Date: Wed, 05 Nov 2008 23:36:48 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
References: <4910C845.4060909@kernel.org> <20081106062608.GC6384@elte.hu>	 <86802c440811052242taefec24ndf661b1c65ca457e@mail.gmail.com>	 <4912943C.2090801@zytor.com> <86802c440811052300y279bd289t74b437a2053b97d1@mail.gmail.com> <491296B2.6090700@zytor.com>
In-Reply-To: <491296B2.6090700@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>> On Wed, Nov 5, 2008 at 10:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Yinghai Lu wrote:
>>>>> Clean-up sidenote: i think we can now remove the VISWS #ifdef portion
>>>>> for good? Mind sending a patch for that too?
>>>> could remove CONFIG_PARAVIRT too.. Jeremy?
>>>>
>>> This seems like a bad idea, especially for the embedded guys.
>>
>> make one CONFIG_NR_IRQS for them before working out one dyna_array is
>> get merged?
>>
> 
> Ah, sorry... I missed the context and thought you meant removing
> CONFIG_PARAVIRT in general.
> 

---
[PATCH] x86: remove VISWS and PARAVIRT around NR_IRQS puzzle

Impact: fix warn when PARAVIRT is set in config

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 503aadc..0005adb 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -101,18 +101,18 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
-#if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_PARAVIRT) && !defined(CONFIG_X86_VISWS) && !defined(CONFIG_X86_VOYAGER)
+#if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_X86_VOYAGER)
 # if NR_CPUS < MAX_IO_APICS
 #  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
 # else
 #  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
 # endif
 
-#elif defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS) || defined(CONFIG_X86_VOYAGER)
+#elif defined(CONFIG_X86_VOYAGER)
 
 # define NR_IRQS		224
 
-#else /* IO_APIC || PARAVIRT */
+#else /* IO_APIC || VOYAGER */
 
 # define NR_IRQS		16
 


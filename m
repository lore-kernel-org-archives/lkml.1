Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbYHIViH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYHIViH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYHIVhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:37:55 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:27535 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYHIVhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=at8a9RGNabdtqMOmThywYezuuKnVJZQGkvc1nCI/q4OxMuOyYln23wiV+VhwqpNjEP
         ukagF4r8x6+pqHdbSZYZpJuy++1CuYKVBotEG9+7iVX2Rm80/3c2x+i8DMIhhcfBm8K2
         mIp+Ax1uQOobKPp240RnJF3QLeScRA3WG0vAA=
Message-ID: <86802c440808091437j3d3b9fcexa4e2da2b981868e8@mail.gmail.com>
Date: Sat, 9 Aug 2008 14:37:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 08/42] introduce nr_irqs
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1fxpeur6u.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
	 <m1ej4zvw6s.fsf@frodo.ebiederm.org>
	 <86802c440808081838r66cc8162t5c2e157908457048@mail.gmail.com>
	 <m1zlnmvhzi.fsf@frodo.ebiederm.org>
	 <86802c440808090030t16e0efa3ne5adad6c8096c8a0@mail.gmail.com>
	 <m1fxpeur6u.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2008 at 8:46 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>
>> ok, will move to that file.
>
> ????   If you introduce a new concept like valid_irq that is fine.
> interrupt.h is the interface to drivers!
>
> Let me say this clearly.
>
> DO NOT CHANGE THE INTERFACE TO DEVICE DRIVERS!
>
please check

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -15,6 +15,8 @@
 #include <asm/ptrace.h>
 #include <asm/system.h>

+extern int nr_irqs;
+
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
  * linux/ioport.h to select the interrupt line behaviour.  When
Index: linux-2.6/arch/m68k/kernel/ints.c
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/ints.c
+++ linux-2.6/arch/m68k/kernel/ints.c
@@ -46,6 +46,8 @@
 #include <asm/q40ints.h>
 #endif

+int nr_irqs = NR_IRQS;
+
 extern u32 auto_irqhandler_fixup[];
 extern u32 user_irqhandler_fixup[];
 extern u16 user_irqvec_fixup[];
Index: linux-2.6/arch/s390/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/irq.c
+++ linux-2.6/arch/s390/kernel/irq.c
@@ -17,6 +17,8 @@
 #include <linux/proc_fs.h>
 #include <linux/profile.h>

+int nr_irqs = NR_IRQS;
+
 /*
  * show_interrupts is needed by /proc/interrupts.
  */
Index: linux-2.6/arch/sparc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/irq.c
+++ linux-2.6/arch/sparc/kernel/irq.c
@@ -55,6 +55,9 @@
 #define SMP_NOP2
 #define SMP_NOP3
 #endif /* SMP */
+
+int nr_irqs = NR_IRQS;
+
 unsigned long __raw_local_irq_save(void)
 {
        unsigned long retval;
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -47,6 +47,7 @@ handle_bad_irq(unsigned int irq, struct
  *
  * Controller mappings for all interrupt sources:
  */
+int nr_irqs = NR_IRQS;
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
        [0 ... NR_IRQS-1] = {
                .status = IRQ_DISABLED,

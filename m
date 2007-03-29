Return-Path: <linux-kernel-owner+w=401wt.eu-S965958AbXC2FLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965958AbXC2FLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 01:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965959AbXC2FLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 01:11:11 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46285 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965958AbXC2FLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 01:11:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yinghai.lu@amd.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64 irq: keep consistent for changing IRQ0_VECTOR from 0x20 to 0x30
References: <86802c440703052359q3242f771ne9c10752613820d3@mail.gmail.com>
	<Pine.LNX.4.64.0703061942000.5963@woody.linux-foundation.org>
	<m1irdcdir5.fsf@ebiederm.dsl.xmission.com>
	<86802c440703282148w29732dcfy5b41a244fad6be4e@mail.gmail.com>
Date: Wed, 28 Mar 2007 23:10:29 -0600
In-Reply-To: <86802c440703282148w29732dcfy5b41a244fad6be4e@mail.gmail.com>
	(Yinghai Lu's message of "Wed, 28 Mar 2007 21:48:38 -0700")
Message-ID: <m1bqicmy7u.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yinghai.lu@amd.com> writes:

> On 3/7/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> The comment fixes or some variation on them are needed.
>
> Please check the patch about comment.
>
> YH
>

Looks good to me.  I've cleaned up the description and placed the patch inline
for easier consumption.  Everything this patch touches is a comment.  So
it is as safe as they come.  And the patch appears to apply to the Linus's
latest tree.

---
From: Yinghai Lu <yinghai.lu@amd.com>
Subject: x86_64 irq: Fix comments after changing IRQ0_VECTOR from 0x20 to 0x30

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Yinghai Lu <yinghai.lu@amd.com>

diff --git a/arch/x86_64/kernel/i8259.c b/arch/x86_64/kernel/i8259.c
index 21d95b7..4894266 100644
--- a/arch/x86_64/kernel/i8259.c
+++ b/arch/x86_64/kernel/i8259.c
@@ -45,7 +45,7 @@
 
 /*
  * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
- * (these are usually mapped to vectors 0x20-0x2f)
+ * (these are usually mapped to vectors 0x30-0x3f)
  */
 
 /*
@@ -299,7 +299,7 @@ void init_8259A(int auto_eoi)
 	 * outb_p - this has to work on a wide range of PC hardware.
 	 */
 	outb_p(0x11, 0x20);	/* ICW1: select 8259A-1 init */
-	outb_p(IRQ0_VECTOR, 0x21);	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 */
+	outb_p(IRQ0_VECTOR, 0x21);	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
 	outb_p(0x04, 0x21);	/* 8259A-1 (the master) has a slave on IR2 */
 	if (auto_eoi)
 		outb_p(0x03, 0x21);	/* master does Auto EOI */
@@ -307,7 +307,7 @@ void init_8259A(int auto_eoi)
 		outb_p(0x01, 0x21);	/* master expects normal EOI */
 
 	outb_p(0x11, 0xA0);	/* ICW1: select 8259A-2 init */
-	outb_p(IRQ8_VECTOR, 0xA1);	/* ICW2: 8259A-2 IR0-7 mapped to 0x28-0x2f */
+	outb_p(IRQ8_VECTOR, 0xA1);	/* ICW2: 8259A-2 IR0-7 mapped to 0x38-0x3f */
 	outb_p(0x02, 0xA1);	/* 8259A-2 is a slave on master's IR2 */
 	outb_p(0x01, 0xA1);	/* (slave's support for AEOI in flat mode
 				    is to be investigated) */
diff --git a/include/asm-x86_64/hw_irq.h b/include/asm-x86_64/hw_irq.h
index 2e4b7a5..6153ae5 100644
--- a/include/asm-x86_64/hw_irq.h
+++ b/include/asm-x86_64/hw_irq.h
@@ -38,7 +38,7 @@
 #define IRQ_MOVE_CLEANUP_VECTOR	FIRST_EXTERNAL_VECTOR
  
 /*
- * Vectors 0x20-0x2f are used for ISA interrupts.
+ * Vectors 0x30-0x3f are used for ISA interrupts.
  */
 #define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR + 0x10
 #define IRQ1_VECTOR		IRQ0_VECTOR + 1

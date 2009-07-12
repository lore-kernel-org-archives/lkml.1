Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZGLLHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZGLLHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 07:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZGLLHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 07:07:23 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:64911 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZGLLHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 07:07:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NIQ3kRInZSHp+/5DDe9jNq85SkA0EOG14+OAmCTtP9Ydxjt86vqGRGoU+rFrCkXV6Y
         xZvN/zPMF9VLP+rvQ61PUUPDs4bHRSTmr6fXk7ilxNERS8HGY0c3Hl/bh3vB3daQxfk+
         sPlq7uwNFXIhgze2T2Nm4nV7hcS1AMzO1L2iQ=
MIME-Version: 1.0
Date: Sun, 12 Jul 2009 17:07:19 +0600
Message-ID: <b9df5fa10907120407p6b4f67dtf4d563155488188a@mail.gmail.com>
Subject: [PATCH] x86,APIC: Fix false positive section mismatch in numaq_32.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Impact: Fix false positive warning.

The variable apic_numaq placed in noninit section references the
function wakeup_secondary_cpu_via_nmi(), which is in __cpuinit
section. Thus causes a section mismatch warning. To avoid such
mismatch we mark apic_numaq as __refdata.

 We were warned by following warning:

WARNING: arch/x86/kernel/built-in.o(.data+0x932c): Section mismatch in
reference from the variable apic_numaq to the function
.cpuinit.text:wakeup_secondary_cpu_via_nmi()
The variable apic_numaq references
the function __cpuinit wakeup_secondary_cpu_via_nmi()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/kernel/apic/numaq_32.c	2009-07-12 11:27:30.000000000 +0600
+++ rakib/arch/x86/kernel/apic/numaq_32.c	2009-07-12 11:28:21.000000000 +0600
@@ -493,7 +493,8 @@ static void numaq_setup_portio_remap(voi
 		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
 }

-struct apic apic_numaq = {
+/* Use __refdata to keep false positive warning calm.	*/
+struct apic __refdata apic_numaq = {

 	.name				= "NUMAQ",
 	.probe				= probe_numaq,

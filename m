Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbXL3VLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbXL3VLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbXL3VLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:11:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbXL3VL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:11:29 -0500
Date: Sun, 30 Dec 2007 22:08:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86] is checkpatch.pl broken
Message-ID: <20071230210835.GA3772@elte.hu>
References: <20071225170737.GA3887@cvg.org> <477196DC.9000704@zytor.com> <aa79d98a0712260238n4848e812l4a66f86b414cc277@mail.gmail.com> <20071230172250.GD22833@elte.hu> <20071230205958.GB7883@cvg.cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230205958.GB7883@cvg.cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> This patch eliminates checkpatch.pl complains on bootflag.c

thanks, applied this to x86.git, to the v2.6.25 queue. See the finalized 
patch below. (I added two more small cleanups that checkpatch did not 
warn about but which were obvious)

	Ingo

----------->
Subject: x86: coding style cleanup for kernel/bootflag.c
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch eliminates checkpatch.pl complaints on bootflag.c

No code changed:

   text    data     bss     dec     hex filename
    321       8       0     329     149 bootflag.o.before
    321       8       0     329     149 bootflag.o.after

   md5:
      9c1b474bcf25ddc1724a29c19880043f  bootflag.o.before.asm
      9c1b474bcf25ddc1724a29c19880043f  bootflag.o.after.asm

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/bootflag.c |   50 ++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

Index: linux-x86.q/arch/x86/kernel/bootflag.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/bootflag.c
+++ linux-x86.q/arch/x86/kernel/bootflag.c
@@ -1,8 +1,6 @@
 /*
  *	Implement 'Simple Boot Flag Specification 2.0'
  */
-
-
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -14,40 +12,38 @@
 
 #include <linux/mc146818rtc.h>
 
-
 #define SBF_RESERVED (0x78)
 #define SBF_PNPOS    (1<<0)
 #define SBF_BOOTING  (1<<1)
 #define SBF_DIAG     (1<<2)
 #define SBF_PARITY   (1<<7)
 
-
 int sbf_port __initdata = -1;	/* set via acpi_boot_init() */
 
-
 static int __init parity(u8 v)
 {
 	int x = 0;
 	int i;
-	
-	for(i=0;i<8;i++)
-	{
-		x^=(v&1);
-		v>>=1;
+
+	for (i = 0; i < 8; i++) {
+		x ^= (v & 1);
+		v >>= 1;
 	}
+
 	return x;
 }
 
 static void __init sbf_write(u8 v)
 {
 	unsigned long flags;
-	if(sbf_port != -1)
-	{
+
+	if (sbf_port != -1) {
 		v &= ~SBF_PARITY;
-		if(!parity(v))
-			v|=SBF_PARITY;
+		if (!parity(v))
+			v |= SBF_PARITY;
 
-		printk(KERN_INFO "Simple Boot Flag at 0x%x set to 0x%x\n", sbf_port, v);
+		printk(KERN_INFO "Simple Boot Flag at 0x%x set to 0x%x\n",
+			sbf_port, v);
 
 		spin_lock_irqsave(&rtc_lock, flags);
 		CMOS_WRITE(v, sbf_port);
@@ -57,33 +53,41 @@ static void __init sbf_write(u8 v)
 
 static u8 __init sbf_read(void)
 {
-	u8 v;
 	unsigned long flags;
-	if(sbf_port == -1)
+	u8 v;
+
+	if (sbf_port == -1)
 		return 0;
+
 	spin_lock_irqsave(&rtc_lock, flags);
 	v = CMOS_READ(sbf_port);
 	spin_unlock_irqrestore(&rtc_lock, flags);
+
 	return v;
 }
 
 static int __init sbf_value_valid(u8 v)
 {
-	if(v&SBF_RESERVED)		/* Reserved bits */
+	if (v & SBF_RESERVED)		/* Reserved bits */
 		return 0;
-	if(!parity(v))
+	if (!parity(v))
 		return 0;
+
 	return 1;
 }
 
 static int __init sbf_init(void)
 {
 	u8 v;
-	if(sbf_port == -1)
+
+	if (sbf_port == -1)
 		return 0;
+
 	v = sbf_read();
-	if(!sbf_value_valid(v))
-		printk(KERN_WARNING "Simple Boot Flag value 0x%x read from CMOS RAM was invalid\n",v);
+	if (!sbf_value_valid(v)) {
+		printk(KERN_WARNING "Simple Boot Flag value 0x%x read from "
+			"CMOS RAM was invalid\n", v);
+	}
 
 	v &= ~SBF_RESERVED;
 	v &= ~SBF_BOOTING;
@@ -92,7 +96,7 @@ static int __init sbf_init(void)
 	v |= SBF_PNPOS;
 #endif
 	sbf_write(v);
+
 	return 0;
 }
-
 module_init(sbf_init);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764079AbYBVWPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764079AbYBVWPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935432AbYBVWKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:10:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761198AbYBVWKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:10:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Tcwojisoh6LDa55sbRh42a4mB+ipFJ3LBQOjaAAs6E1pi0uWGlKWyYAfZOUetBEhFGt2z8Ol2GBWrhRr3qujnX1d71C/KzVf3bEmmWCe2298/DLtHI25GTX2DjcPLu76/2VPvODnlhAIGQQODjg0/MxDHv7ri6Y5akWg8CaZYZ4=
Date: Fri, 22 Feb 2008 23:10:33 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/20] x86: Coding Style fixes to arch/x86/kernel/cpu/amd.c
Message-ID: <20080222231033.4fa806aa@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/amd.c |   94 +++++++++++++++++++++++----------------------
 1 files changed, 48 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index cab4e56..1a3e1bb 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -20,7 +20,7 @@
  *	the chip setting when fixing the bug but they also tweaked some
  *	performance at the same time..
  */
- 
+
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
@@ -81,7 +81,8 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 #ifdef CONFIG_SMP
 	unsigned long long value;
 
-	/* Disable TLB flush filter by setting HWCR.FFDIS on K8
+	/*
+	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
 	 * bit 6 of msr C001_0015
 	 *
 	 * Errata 63 for SH-B3 steppings
@@ -102,15 +103,16 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	 *	no bus pipeline)
 	 */
 
-	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
-	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
+	/*
+	 * Bit 31 in normal CPUID used for nonstandard 3DNow ID;
+	 * DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
+	 */
 	clear_bit(0*32+31, c->x86_capability);
-	
+
 	r = get_model_name(c);
 
-	switch(c->x86)
-	{
-		case 4:
+	switch (c->x86) {
+	case 4:
 		/*
 		 * General Systems BIOSen alias the cpu frequency registers
 		 * of the Elan at 0x000df000. Unfortuantly, one of the Linux
@@ -120,61 +122,60 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 #define CBAR		(0xfffc) /* Configuration Base Address  (32-bit) */
 #define CBAR_ENB	(0x80000000)
 #define CBAR_KEY	(0X000000CB)
-			if (c->x86_model==9 || c->x86_model == 10) {
+			if (c->x86_model == 9 || c->x86_model == 10) {
 				if (inl (CBAR) & CBAR_ENB)
 					outl (0 | CBAR_KEY, CBAR);
 			}
 			break;
-		case 5:
-			if( c->x86_model < 6 )
-			{
+	case 5:
+			if (c->x86_model < 6) {
 				/* Based on AMD doc 20734R - June 2000 */
-				if ( c->x86_model == 0 ) {
+				if (c->x86_model == 0) {
 					clear_bit(X86_FEATURE_APIC, c->x86_capability);
 					set_bit(X86_FEATURE_PGE, c->x86_capability);
 				}
 				break;
 			}
-			
-			if ( c->x86_model == 6 && c->x86_mask == 1 ) {
+
+			if (c->x86_model == 6 && c->x86_mask == 1) {
 				const int K6_BUG_LOOP = 1000000;
 				int n;
 				void (*f_vide)(void);
 				unsigned long d, d2;
-				
+
 				printk(KERN_INFO "AMD K6 stepping B detected - ");
-				
+
 				/*
-				 * It looks like AMD fixed the 2.6.2 bug and improved indirect 
+				 * It looks like AMD fixed the 2.6.2 bug and improved indirect
 				 * calls at the same time.
 				 */
 
 				n = K6_BUG_LOOP;
 				f_vide = vide;
 				rdtscl(d);
-				while (n--) 
+				while (n--)
 					f_vide();
 				rdtscl(d2);
 				d = d2-d;
 
-				if (d > 20*K6_BUG_LOOP) 
+				if (d > 20*K6_BUG_LOOP)
 					printk("system stability may be impaired when more than 32 MB are used.\n");
-				else 
+				else
 					printk("probably OK (after B9730xxxx).\n");
 				printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
 			}
 
 			/* K6 with old style WHCR */
 			if (c->x86_model < 8 ||
-			   (c->x86_model== 8 && c->x86_mask < 8)) {
+			   (c->x86_model == 8 && c->x86_mask < 8)) {
 				/* We can only write allocate on the low 508Mb */
-				if(mbytes>508)
-					mbytes=508;
+				if (mbytes > 508)
+					mbytes = 508;
 
 				rdmsr(MSR_K6_WHCR, l, h);
-				if ((l&0x0000FFFF)==0) {
+				if ((l&0x0000FFFF) == 0) {
 					unsigned long flags;
-					l=(1<<0)|((mbytes/4)<<1);
+					l = (1<<0)|((mbytes/4)<<1);
 					local_irq_save(flags);
 					wbinvd();
 					wrmsr(MSR_K6_WHCR, l, h);
@@ -185,17 +186,17 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 				break;
 			}
 
-			if ((c->x86_model == 8 && c->x86_mask >7) ||
+			if ((c->x86_model == 8 && c->x86_mask > 7) ||
 			     c->x86_model == 9 || c->x86_model == 13) {
 				/* The more serious chips .. */
 
-				if(mbytes>4092)
-					mbytes=4092;
+				if (mbytes > 4092)
+					mbytes = 4092;
 
 				rdmsr(MSR_K6_WHCR, l, h);
-				if ((l&0xFFFF0000)==0) {
+				if ((l&0xFFFF0000) == 0) {
 					unsigned long flags;
-					l=((mbytes>>2)<<22)|(1<<16);
+					l = ((mbytes>>2)<<22)|(1<<16);
 					local_irq_save(flags);
 					wbinvd();
 					wrmsr(MSR_K6_WHCR, l, h);
@@ -217,10 +218,11 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 				break;
 			}
 			break;
-		case 6: /* An Athlon/Duron */
- 
-			/* Bit 15 of Athlon specific MSR 15, needs to be 0
- 			 * to enable SSE on Palomino/Morgan/Barton CPU's.
+	case 6: /* An Athlon/Duron */
+
+			/*
+			 * Bit 15 of Athlon specific MSR 15, needs to be 0
+			 * to enable SSE on Palomino/Morgan/Barton CPU's.
 			 * If the BIOS didn't enable it already, enable it here.
 			 */
 			if (c->x86_model >= 6 && c->x86_model <= 10) {
@@ -233,11 +235,12 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 				}
 			}
 
-			/* It's been determined by AMD that Athlons since model 8 stepping 1
+			/*
+			 * It's been determined by AMD that Athlons since model 8 stepping 1
 			 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
 			 * As per AMD technical note 27212 0.2
 			 */
-			if ((c->x86_model == 8 && c->x86_mask>=1) || (c->x86_model > 8)) {
+			if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
 				rdmsr(MSR_K7_CLK_CTL, l, h);
 				if ((l & 0xfff00000) != 0x20000000) {
 					printk ("CPU: CLK_CTL MSR was %x. Reprogramming to %x\n", l,
@@ -256,7 +259,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		set_bit(X86_FEATURE_K8, c->x86_capability);
 		break;
 	case 6:
-		set_bit(X86_FEATURE_K7, c->x86_capability); 
+		set_bit(X86_FEATURE_K7, c->x86_capability);
 		break;
 	}
 	if (c->x86 >= 6)
@@ -264,9 +267,8 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 
 	display_cacheinfo(c);
 
-	if (cpuid_eax(0x80000000) >= 0x80000008) {
+	if (cpuid_eax(0x80000000) >= 0x80000008)
 		c->x86_max_cores = (cpuid_ecx(0x80000008) & 0xff) + 1;
-	}
 
 #ifdef CONFIG_X86_HT
 	/*
@@ -308,14 +310,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		set_bit(X86_FEATURE_MFENCE_RDTSC, c->x86_capability);
 }
 
-static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 * c, unsigned int size)
+static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/* AMD errata T13 (order #21922) */
 	if ((c->x86 == 6)) {
 		if (c->x86_model == 3 && c->x86_mask == 0)	/* Duron Rev A0 */
 			size = 64;
 		if (c->x86_model == 4 &&
-		    (c->x86_mask==0 || c->x86_mask==1))	/* Tbird rev A1/A2 */
+		    (c->x86_mask == 0 || c->x86_mask == 1))	/* Tbird rev A1/A2 */
 			size = 256;
 	}
 	return size;
@@ -323,16 +325,16 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 * c, unsigned in
 
 static struct cpu_dev amd_cpu_dev __cpuinitdata = {
 	.c_vendor	= "AMD",
-	.c_ident 	= { "AuthenticAMD" },
+	.c_ident	= { "AuthenticAMD" },
 	.c_models = {
 		{ .vendor = X86_VENDOR_AMD, .family = 4, .model_names =
 		  {
 			  [3] = "486 DX/2",
 			  [7] = "486 DX/2-WB",
-			  [8] = "486 DX/4", 
-			  [9] = "486 DX/4-WB", 
+			  [8] = "486 DX/4",
+			  [9] = "486 DX/4-WB",
 			  [14] = "Am5x86-WT",
-			  [15] = "Am5x86-WB" 
+			  [15] = "Am5x86-WB"
 		  }
 		},
 	},
-- 
1.5.4.GIT


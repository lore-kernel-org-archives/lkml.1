Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbXJVTNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbXJVTNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbXJVTM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:12:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756AbXJVTMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:12:25 -0400
Date: Mon, 22 Oct 2007 15:12:24 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: CodingStyle nits in sbf.c
Message-ID: <20071022191224.GA23273@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

misplaced brackets, 80 columns, whitespace.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/bootflag.c b/arch/x86/kernel/bootflag.c
index 0b98605..85fc177 100644
--- a/arch/x86/kernel/bootflag.c
+++ b/arch/x86/kernel/bootflag.c
@@ -30,10 +30,9 @@ static int __init parity(u8 v)
 	int x = 0;
 	int i;
 	
-	for(i=0;i<8;i++)
-	{
-		x^=(v&1);
-		v>>=1;
+	for (i=0; i<8; i++) {
+		x ^= (v & 1);
+		v >>= 1;
 	}
 	return x;
 }
@@ -41,13 +40,13 @@ static int __init parity(u8 v)
 static void __init sbf_write(u8 v)
 {
 	unsigned long flags;
-	if(sbf_port != -1)
-	{
+	if (sbf_port != -1) {
 		v &= ~SBF_PARITY;
-		if(!parity(v))
+		if (!parity(v))
 			v|=SBF_PARITY;
 
-		printk(KERN_INFO "Simple Boot Flag at 0x%x set to 0x%x\n", sbf_port, v);
+		printk(KERN_INFO "Simple Boot Flag at 0x%x "
+			"set to 0x%x\n", sbf_port, v);
 
 		spin_lock_irqsave(&rtc_lock, flags);
 		CMOS_WRITE(v, sbf_port);
@@ -59,7 +58,7 @@ static u8 __init sbf_read(void)
 {
 	u8 v;
 	unsigned long flags;
-	if(sbf_port == -1)
+	if (sbf_port == -1)
 		return 0;
 	spin_lock_irqsave(&rtc_lock, flags);
 	v = CMOS_READ(sbf_port);
@@ -69,9 +68,9 @@ static u8 __init sbf_read(void)
 
 static int __init sbf_value_valid(u8 v)
 {
-	if(v&SBF_RESERVED)		/* Reserved bits */
+	if (v & SBF_RESERVED)		/* Reserved bits */
 		return 0;
-	if(!parity(v))
+	if (!parity(v))
 		return 0;
 	return 1;
 }
@@ -79,11 +78,12 @@ static int __init sbf_value_valid(u8 v)
 static int __init sbf_init(void)
 {
 	u8 v;
-	if(sbf_port == -1)
+	if (sbf_port == -1)
 		return 0;
 	v = sbf_read();
-	if(!sbf_value_valid(v))
-		printk(KERN_WARNING "Simple Boot Flag value 0x%x read from CMOS RAM was invalid\n",v);
+	if (!sbf_value_valid(v))
+		printk(KERN_WARNING "Simple Boot Flag value 0x%x "
+			"read from CMOS RAM was invalid\n",v);
 
 	v &= ~SBF_RESERVED;
 	v &= ~SBF_BOOTING;

-- 
http://www.codemonkey.org.uk

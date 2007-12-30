Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbXL3VAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbXL3VAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXL3VAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:00:12 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:64244 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXL3VAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:00:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mSIvRbphQuyrP/mrv32MKt8KqOp0bSqaE9+ATeTRYmP4K29N/iO2xbqaLPfFb+l7hfYJvDErpJQZTdUiw+ffpDoky6alaGUZoTgiCuPkEv0+bMlEQGjJavTRQd2Lxv+sjERanJXP8GeBl1nyhLbtOPv71yqI0nAhick725cQNlU=
Date: Sun, 30 Dec 2007 23:59:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86] is checkpatch.pl broken
Message-ID: <20071230205958.GB7883@cvg.cvg>
References: <20071225170737.GA3887@cvg.org> <477196DC.9000704@zytor.com> <aa79d98a0712260238n4848e812l4a66f86b414cc277@mail.gmail.com> <20071230172250.GD22833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230172250.GD22833@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Dec 30, 2007 at 06:22:50PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > orig:
| > mbr_base = (buf_base+sector_size-1) & ~(sector_size-1);
| > new (could be):
| > mbr_base = (buf_base + sector_size - 1) & ~(sector_size - 1);
| > 
| > Is a new version that bad?
| 
| it's certainly acceptable as newly introduced code but only borderline 
| better than the original code. I'd suggest to stick to the problem areas 
| that checkpatch.pl complains about at the moment - we have really 
| obvious bad looking pieces of code that checkpatch.pl reports, and going 
| after the borderline cases will only result in coding-style lawyering 
| and flamewars, not any genuine increase in code quality ;-)
| 
| for example:
| 
|   arch/x86/kernel/bootflag.c:
| 
|   total: 19 errors, 2 warnings, 98 lines checked
| 
| or:
| 
|   arch/x86/kernel/apm_32.c:
| 
|   total: 56 errors, 31 warnings, 2402 lines checked
| 
| and once we have nothing but the borderline cases and if we get really 
| bored we can start coding style flamewars ;-)
| 
| 	Ingo
| 

Hi Ingo,
here is a first for x86 tree

		- Cyrill -
---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [x86] coding style cleanup for kernel/bootflag.c

This patch eliminates checkpatch.pl complains
on bootflag.c

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 arch/x86/kernel/bootflag.c |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/bootflag.c b/arch/x86/kernel/bootflag.c
index 0b98605..1697e49 100644
--- a/arch/x86/kernel/bootflag.c
+++ b/arch/x86/kernel/bootflag.c
@@ -24,30 +24,29 @@
 
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
@@ -59,31 +58,38 @@ static u8 __init sbf_read(void)
 {
 	u8 v;
 	unsigned long flags;
-	if(sbf_port == -1)
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
+	if (!sbf_value_valid(v))
+		printk(KERN_WARNING "Simple Boot Flag value 0x%x read from "
+			"CMOS RAM was invalid\n", v);
 
 	v &= ~SBF_RESERVED;
 	v &= ~SBF_BOOTING;

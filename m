Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYEMAkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYEMAkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 20:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYEMAke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 20:40:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:19548 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbYEMAkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 20:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=f5XfdZFvQrSYSekASXJ1Mfa7kpLAKHGBnRrXKQQsceqN7cRSnnUoG7HEHpQFGCTcbnp5EUvriMeRQTT3uat9kPMtmdczQYF4u1IP9j9uoymeEBatJ1sx3Skq2A+8fduyHi91v5mzHXiFcdiNxQU/ZIIXoOv/UDBpbCo6pKdu0E4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: amd opteron TOM2 mask val fix
Date: Mon, 12 May 2008 17:40:39 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805121740.40070.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


there is typo with the mask. need to remove that extra 0. to avoid 4bits was cleared.

Signed-off-by: Yinghal Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
@@ -233,7 +233,7 @@ void __init get_mtrr_state(void)
 		mtrr_tom2 = high;
 		mtrr_tom2 <<= 32;
 		mtrr_tom2 |= low;
-		mtrr_tom2 &= 0xffffff8000000ULL;
+		mtrr_tom2 &= 0xffffff800000ULL;
 	}
 	if (mtrr_show) {
 		int high_width;
Index: linux-2.6/arch/x86/pci/k8-bus_64.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/k8-bus_64.c
+++ linux-2.6/arch/x86/pci/k8-bus_64.c
@@ -384,7 +384,7 @@ static int __init early_fill_mp_bus_info
 	/* need to take out [0, TOM) for RAM*/
 	address = MSR_K8_TOP_MEM1;
 	rdmsrl(address, val);
-	end = (val & 0xffffff8000000ULL);
+	end = (val & 0xffffff800000ULL);
 	printk(KERN_INFO "TOM: %016lx aka %ldM\n", end, end>>20);
 	if (end < (1ULL<<32))
 		update_range(range, 0, end - 1);
@@ -478,7 +478,7 @@ static int __init early_fill_mp_bus_info
 		/* TOP_MEM2 */
 		address = MSR_K8_TOP_MEM2;
 		rdmsrl(address, val);
-		end = (val & 0xffffff8000000ULL);
+		end = (val & 0xffffff800000ULL);
 		printk(KERN_INFO "TOM2: %016lx aka %ldM\n", end, end>>20);
 		update_range(range, 1ULL<<32, end - 1);
 	}

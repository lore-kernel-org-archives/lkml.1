Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbYI0Hax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbYI0Hax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 03:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYI0Hap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 03:30:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:60541 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYI0Hao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 03:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UDYeEsAeBP089RXVwmuFe/8EmV7jDuzMOx4pJwBz8Ki3yp9GcdLo3x8ebet/DiQlG8
         145aeml838NtFGJjuBYMC6G5cJM4byK7Z0f4xp9F463uVWDKq2xPzmRID/btb3Ll7Bpg
         E4nsb9sXJRyTDWx5EFluVn7Zuu0+cwvOVRCLQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/3] x86: add mtrr_cleanup_debug command line
Date: Sat, 27 Sep 2008 00:30:06 -0700
Message-Id: <1222500608-14855-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 add mtrr_cleanup_debug to print out more info about layout

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/mtrr/main.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -836,6 +836,13 @@ static int __init enable_mtrr_cleanup_se
 }
 early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
 
+static int __init mtrr_cleanup_debug_setup(char *str)
+{
+	debug_print = 1;
+	return 0;
+}
+early_param("mtrr_cleanup_debug", mtrr_cleanup_debug_setup);
+
 struct var_mtrr_state {
 	unsigned long	range_startk;
 	unsigned long	range_sizek;
@@ -1231,7 +1238,7 @@ static int __init mtrr_cleanup(unsigned
 	if (mtrr_chunk_size && mtrr_gran_size) {
 		int num_reg;
 
-		debug_print = 1;
+		debug_print++;
 		/* convert ranges to var ranges state */
 		num_reg = x86_setup_var_mtrrs(range, nr_range, mtrr_chunk_size,
 					      mtrr_gran_size);
@@ -1267,7 +1274,7 @@ static int __init mtrr_cleanup(unsigned
 		}
 		printk(KERN_INFO "invalid mtrr_gran_size or mtrr_chunk_size, "
 		       "will find optimal one\n");
-		debug_print = 0;
+		debug_print--;
 		memset(result, 0, sizeof(result[0]));
 	}
 
@@ -1370,8 +1377,9 @@ static int __init mtrr_cleanup(unsigned
 		chunk_size <<= 10;
 		gran_size = result[i].gran_sizek;
 		gran_size <<= 10;
-		debug_print = 1;
+		debug_print++;
 		x86_setup_var_mtrrs(range, nr_range, chunk_size, gran_size);
+		debug_print--;
 		set_var_mtrr_all(address_bits);
 		return 1;
 	}

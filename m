Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYDPGST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYDPGST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 02:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYDPGSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 02:18:06 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:37375 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932AbYDPGSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 02:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=puxUMgUF9FRrVRR9O2qjY9PKnjkaZ21Xry6Hih2UjNoKs8+K3vMXcgf7dlgktxQXDsjdyS47k7Cjk9wVjFgrXfiMYWoDBYV5g3ZgZE/43TG5MGemdUahLy0PSh81cpfhKgCBZ23iutxVb4CTfNCsrDIFz4ONrAB183GAMMCGF0M=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86_64: fix memtest print out
Date: Tue, 15 Apr 2008 23:17:42 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804152317.42886.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 058552e..0671f11 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -478,7 +478,7 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
 				last_bad += incr;
 			} else {
 				if (start_bad) {
-					printk(KERN_INFO "  %016lxx bad mem addr %016lx - %016lx reserved\n",
+					printk(KERN_CONT "\n  %016lx bad mem addr %016lx - %016lx reserved",
 						val, start_bad, last_bad + incr);
 					reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
 				}
@@ -487,7 +487,7 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
 		}
 	}
 	if (start_bad) {
-		printk(KERN_INFO "  %016lx bad mem addr %016lx - %016lx reserved\n",
+		printk(KERN_CONT "\n  %016lx bad mem addr %016lx - %016lx reserved",
 			val, start_bad, last_bad + incr);
 		reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
 	}

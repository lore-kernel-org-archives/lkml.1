Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbYEDRAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbYEDRAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYEDRAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:00:07 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54784 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYEDRAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:00:06 -0400
Date: Sun, 4 May 2008 19:58:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Roman Zippel <zippel@linux-m68k.org>, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] mips/emma2rh/markeins/setup.c build fix
Message-ID: <20080504165850.GM5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build errror caused by
commit 7dffa3c673fbcf835cd7be80bb4aec8ad3f51168
(ntp: handle leap second via timer):

<--  snip  -->

...
  CC      arch/mips/emma2rh/markeins/setup.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/emma2rh/markeins/setup.c:79: error: conflicting types for 'clock'
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/clocksource.h:96: error: previous declaration of 'clock' was here
make[2]: *** [arch/mips/emma2rh/markeins/setup.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/mips/emma2rh/markeins/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

139244b9f3cd31793da682da14c67e38836bec36 diff --git a/arch/mips/emma2rh/markeins/setup.c b/arch/mips/emma2rh/markeins/setup.c
index 82f9e90..487cac5 100644
--- a/arch/mips/emma2rh/markeins/setup.c
+++ b/arch/mips/emma2rh/markeins/setup.c
@@ -76,7 +76,7 @@ static void markeins_machine_power_off(void)
 	while (1) ;
 }
 
-static unsigned long clock[4] = { 166500000, 187312500, 199800000, 210600000 };
+static unsigned long emma2rh_clock[4] = { 166500000, 187312500, 199800000, 210600000 };
 
 static unsigned int __init detect_bus_frequency(unsigned long rtc_base)
 {
@@ -85,7 +85,7 @@ static unsigned int __init detect_bus_frequency(unsigned long rtc_base)
 	/* detect from boot strap */
 	reg = emma2rh_in32(EMMA2RH_BHIF_STRAP_0);
 	reg = (reg >> 4) & 0x3;
-	return clock[reg];
+	return emma2rh_clock[reg];
 }
 
 void __init plat_time_init(void)


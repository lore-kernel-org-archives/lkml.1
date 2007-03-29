Return-Path: <linux-kernel-owner+w=401wt.eu-S1030201AbXC2KlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030201AbXC2KlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 06:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030202AbXC2KlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 06:41:20 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:9497 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030201AbXC2KlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 06:41:19 -0400
X-IronPort-AV: i="4.14,345,1170651600"; 
   d="scan'208"; a="25807729:sNHT20723010"
Subject: [PATCH] blackfin arch fix bug prevent warning in case BF531 is
	target
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 29 Mar 2007 18:42:13 +0800
Message-Id: <1175164933.15391.37.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 96ee2fa..ce51882 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -571,7 +571,7 @@ static void __init generate_cpl_tables(void)
 			 * rootfs size, there can be overlapping memory areas.
 			 */
 
-			if (as_1m) {
+			if (as_1m &&  i!=L1I_MEM && i!=L1D_MEM) {
 #ifdef CONFIG_MTD_UCLINUX
 				if (i == SDRAM_RAM_MTD) {
 					if ((cplb_data[SDRAM_KERN].end + 1) > cplb_data[SDRAM_RAM_MTD].start)
-- 
1.5.0.5


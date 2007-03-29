Return-Path: <linux-kernel-owner+w=401wt.eu-S934061AbXC2Kia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbXC2Kia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 06:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934278AbXC2Kia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 06:38:30 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:48182 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbXC2Ki3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 06:38:29 -0400
X-IronPort-AV: i="4.14,345,1170651600"; 
   d="scan'208"; a="25807581:sNHT27504869"
Subject: [PATCH -mm] blackfin arch fix bug bf561 rev ID are 8-bit
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 29 Mar 2007 18:39:15 +0800
Message-Id: <1175164756.15391.31.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c            |    3 +++
 include/asm-blackfin/mach-bf561/bf561.h |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index b494f73..96ee2fa 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -117,6 +117,9 @@ static u_int get_dsp_rev_id(void)
 {
 	u_int id;
 	id = bfin_read_DSPID() & 0xffff;
+#if defined(CONFIG_BF561)
+	id>>=8;
+#endif
 	return id;
 }
 
diff --git a/include/asm-blackfin/mach-bf561/bf561.h b/include/asm-blackfin/mach-bf561/bf561.h
index cd90a1c..ded1796 100644
--- a/include/asm-blackfin/mach-bf561/bf561.h
+++ b/include/asm-blackfin/mach-bf561/bf561.h
@@ -30,7 +30,7 @@
 #ifndef __MACH_BF561_H__
 #define __MACH_BF561_H__
 
-#define SUPPORTED_DSPID		0x300
+#define SUPPORTED_DSPID		0x3
 
 #define OFFSET_(x) ((x) & 0x0000FFFF)
 #define L1_ISRAM		0xFFA00000
-- 
1.5.0.5


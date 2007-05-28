Return-Path: <linux-kernel-owner+w=401wt.eu-S932161AbXE1Ii1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbXE1Ii1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761193AbXE1Igj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:39 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:22622 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759060AbXE1Igd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:33 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="40300048:sNHT27093094"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Roy Huang <roy.huang@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 04/20] Blackfin arch:  fix bug ad1836 fails to build properly for BF533-EZKIT
Date: Mon, 28 May 2007 16:37:39 +0800
Message-Id: <11803414772603-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roy Huang <roy.huang@analog.com>

bug log here: http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3166

Signed-off-by: Roy Huang <roy.huang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/mach-common/def_LPBlackfin.h |   22 +++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/asm-blackfin/mach-common/def_LPBlackfin.h b/include/asm-blackfin/mach-common/def_LPBlackfin.h
index 7610352..fcda2c1 100644
--- a/include/asm-blackfin/mach-common/def_LPBlackfin.h
+++ b/include/asm-blackfin/mach-common/def_LPBlackfin.h
@@ -42,6 +42,12 @@
 
 #if defined(ANOMALY_05000198)
 
+#define bfin_read8(addr) ({ unsigned char __v; \
+		__asm__ __volatile__ ("NOP;\n\t" \
+			"%0 = b[%1] (z);\n\t" \
+			: "=d"(__v) : "a"(addr)); \
+		__v; })
+
 #define bfin_read16(addr) ({ unsigned __v; \
                        __asm__ __volatile__ ("NOP;\n\t"\
 	         			     			"%0 = w[%1] (z);\n\t"\
@@ -52,6 +58,11 @@
                                             "%0 = [%1];\n\t"\
   : "=d"(__v) : "a"(addr)); __v; })
 
+#define bfin_write8(addr,val) ({ \
+		__asm__ __volatile__ ("NOP;\n\t" \
+			"b[%0] = %1;\n\t" \
+			: : "a"(addr), "d"(val) : "memory");})
+
 #define bfin_write16(addr,val) ({\
                       __asm__ __volatile__ ("NOP;\n\t"\
                                             "w[%0] = %1;\n\t"\
@@ -64,6 +75,12 @@
 
 #else
 
+#define bfin_read8(addr) ({ unsigned char __v; \
+		__asm__ __volatile__ ( \
+			"%0 = b[%1] (z);\n\t" \
+			:"=d"(__v) : "a"(addr)); \
+		__v; })
+
 #define bfin_read16(addr) ({ unsigned __v; \
                        __asm__ __volatile__ (\
 	         			     			"%0 = w[%1] (z);\n\t"\
@@ -74,6 +91,11 @@
                                             "%0 = [%1];\n\t"\
   : "=d"(__v) : "a"(addr)); __v; })
 
+#define bfin_write8(addr, val) ({ \
+		__asm__ __volatile__ ( \
+			"b[%0] = %1; \n\t" \
+			::"a"(addr), "d"(val) : "memory");})
+
 #define bfin_write16(addr,val) ({\
                       __asm__ __volatile__ (\
                                             "w[%0] = %1;\n\t"\
-- 
1.5.2

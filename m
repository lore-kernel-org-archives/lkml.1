Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYDJCcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYDJCcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 22:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYDJCb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 22:31:58 -0400
Received: from mail.queued.net ([207.210.101.209]:2471 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbYDJCb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 22:31:57 -0400
Date: Wed, 9 Apr 2008 22:33:28 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       info-linux@geode.amd.com, jordan.crouse@amd.com
Subject: [PATCH 2/3] x86: GEODE: add Virtual Systems Architecture detection
Message-ID: <20080409223328.5774d6cf@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is generic VSA detection.  It's used by OLPC to determine whether or
not the BIOS contains VSA, but since other BIOSes are coming out that don't
use the VSA (ie, tinybios), it might end up being useful for others.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 include/asm-x86/geode.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index c208398..882acf8 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -103,6 +103,14 @@ extern int geode_get_dev_base(unsigned int dev);
 #define PM_AWKD			0x50
 #define PM_SSC			0x54
 
+/* VSA magic values */
+
+#define VSA_VRC_INDEX		0xAC1C
+#define VSA_VRC_DATA		0xAC1E
+#define VSA_VR_UNLOCK		0xFC53	/* unlock virtual register */
+#define VSA_VR_SIGNATURE	0x0003
+#define VSA_SIG			0x4132	/* signature is ascii 'VSA2' */
+
 /* GPIO */
 
 #define GPIO_OUTPUT_VAL		0x00
@@ -174,6 +182,14 @@ static inline int is_geode(void)
 	return (is_geode_gx() || is_geode_lx());
 }
 
+static inline int geode_has_vsa(void)
+{
+	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+	outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
+
+	return (inw(VSA_VRC_DATA) == VSA_SIG);
+}
+
 /* MFGPTs */
 
 #define MFGPT_MAX_TIMERS	8
-- 
1.5.4.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505Ab0ADOsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0ADOsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 09:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415Ab0ADOsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 09:48:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab0ADOsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 09:48:16 -0500
Date: Mon, 4 Jan 2010 09:47:35 -0500
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: macroise x86 cache descriptors.
Message-ID: <20100104144735.GA18390@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a macro to define the cache sizes when cachesize > 1 MB
This is less typing, and less prone to introducing bugs like we saw
in e02e0e1a130b9ca37c5186d38ad4b3aaf58bb149, and means we don't have
to do maths when adding new non-power-of-2 updates like those seen recently.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index fc6c8ef..c2b722d 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -31,6 +31,8 @@ struct _cache_table {
 	short size;
 };
 
+#define MB(x)	((x) * 1024)
+
 /* All the cache descriptor types we care about (no TLB or
    trace cache entries) */
 
@@ -44,9 +46,9 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x0d, LVL_1_DATA, 16 },	/* 4-way set assoc, 64 byte line size */
 	{ 0x21, LVL_2,      256 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x22, LVL_3,      512 },	/* 4-way set assoc, sectored cache, 64 byte line size */
-	{ 0x23, LVL_3,      1024 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x25, LVL_3,      2048 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x29, LVL_3,      4096 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x23, LVL_3,      MB(1) },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x25, LVL_3,      MB(2) },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x29, LVL_3,      MB(4) },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x2c, LVL_1_DATA, 32 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x30, LVL_1_INST, 32 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x39, LVL_2,      128 },	/* 4-way set assoc, sectored cache, 64 byte line size */
@@ -59,16 +61,16 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x41, LVL_2,      128 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x42, LVL_2,      256 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x43, LVL_2,      512 },	/* 4-way set assoc, 32 byte line size */
-	{ 0x44, LVL_2,      1024 },	/* 4-way set assoc, 32 byte line size */
-	{ 0x45, LVL_2,      2048 },	/* 4-way set assoc, 32 byte line size */
-	{ 0x46, LVL_3,      4096 },	/* 4-way set assoc, 64 byte line size */
-	{ 0x47, LVL_3,      8192 },	/* 8-way set assoc, 64 byte line size */
-	{ 0x49, LVL_3,      4096 },	/* 16-way set assoc, 64 byte line size */
-	{ 0x4a, LVL_3,      6144 },	/* 12-way set assoc, 64 byte line size */
-	{ 0x4b, LVL_3,      8192 },	/* 16-way set assoc, 64 byte line size */
-	{ 0x4c, LVL_3,     12288 },	/* 12-way set assoc, 64 byte line size */
-	{ 0x4d, LVL_3,     16384 },	/* 16-way set assoc, 64 byte line size */
-	{ 0x4e, LVL_2,      6144 },	/* 24-way set assoc, 64 byte line size */
+	{ 0x44, LVL_2,      MB(1) },	/* 4-way set assoc, 32 byte line size */
+	{ 0x45, LVL_2,      MB(2) },	/* 4-way set assoc, 32 byte line size */
+	{ 0x46, LVL_3,      MB(4) },	/* 4-way set assoc, 64 byte line size */
+	{ 0x47, LVL_3,      MB(8) },	/* 8-way set assoc, 64 byte line size */
+	{ 0x49, LVL_3,      MB(4) },	/* 16-way set assoc, 64 byte line size */
+	{ 0x4a, LVL_3,      MB(6) },	/* 12-way set assoc, 64 byte line size */
+	{ 0x4b, LVL_3,      MB(8) },	/* 16-way set assoc, 64 byte line size */
+	{ 0x4c, LVL_3,      MB(12) },	/* 12-way set assoc, 64 byte line size */
+	{ 0x4d, LVL_3,      MB(16) },	/* 16-way set assoc, 64 byte line size */
+	{ 0x4e, LVL_2,      MB(6) },	/* 24-way set assoc, 64 byte line size */
 	{ 0x60, LVL_1_DATA, 16 },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x66, LVL_1_DATA, 8 },	/* 4-way set assoc, sectored cache, 64 byte line size */
 	{ 0x67, LVL_1_DATA, 16 },	/* 4-way set assoc, sectored cache, 64 byte line size */
@@ -77,34 +79,34 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x71, LVL_TRACE,  16 },	/* 8-way set assoc */
 	{ 0x72, LVL_TRACE,  32 },	/* 8-way set assoc */
 	{ 0x73, LVL_TRACE,  64 },	/* 8-way set assoc */
-	{ 0x78, LVL_2,    1024 },	/* 4-way set assoc, 64 byte line size */
-	{ 0x79, LVL_2,     128 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7a, LVL_2,     256 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7b, LVL_2,     512 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7c, LVL_2,    1024 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7d, LVL_2,    2048 },	/* 8-way set assoc, 64 byte line size */
-	{ 0x7f, LVL_2,     512 },	/* 2-way set assoc, 64 byte line size */
-	{ 0x82, LVL_2,     256 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x83, LVL_2,     512 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x84, LVL_2,    1024 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x85, LVL_2,    2048 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x86, LVL_2,     512 },	/* 4-way set assoc, 64 byte line size */
-	{ 0x87, LVL_2,    1024 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd0, LVL_3,     512 },	/* 4-way set assoc, 64 byte line size */
-	{ 0xd1, LVL_3,    1024 },	/* 4-way set assoc, 64 byte line size */
-	{ 0xd2, LVL_3,    2048 },	/* 4-way set assoc, 64 byte line size */
-	{ 0xd6, LVL_3,    1024 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd7, LVL_3,    2048 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd8, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xdc, LVL_3,    2048 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xdd, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xde, LVL_3,    8192 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xe2, LVL_3,    2048 },	/* 16-way set assoc, 64 byte line size */
-	{ 0xe3, LVL_3,    4096 },	/* 16-way set assoc, 64 byte line size */
-	{ 0xe4, LVL_3,    8192 },	/* 16-way set assoc, 64 byte line size */
-	{ 0xea, LVL_3,    12288 },	/* 24-way set assoc, 64 byte line size */
-	{ 0xeb, LVL_3,    18432 },	/* 24-way set assoc, 64 byte line size */
-	{ 0xec, LVL_3,    24576 },	/* 24-way set assoc, 64 byte line size */
+	{ 0x78, LVL_2,      MB(1) },	/* 4-way set assoc, 64 byte line size */
+	{ 0x79, LVL_2,      128 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7a, LVL_2,      256 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7b, LVL_2,      512 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7c, LVL_2,      MB(1) },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7d, LVL_2,      MB(2) },	/* 8-way set assoc, 64 byte line size */
+	{ 0x7f, LVL_2,      512 },	/* 2-way set assoc, 64 byte line size */
+	{ 0x82, LVL_2,      256 },	/* 8-way set assoc, 32 byte line size */
+	{ 0x83, LVL_2,      512 },	/* 8-way set assoc, 32 byte line size */
+	{ 0x84, LVL_2,      MB(1) },	/* 8-way set assoc, 32 byte line size */
+	{ 0x85, LVL_2,      MB(2) },	/* 8-way set assoc, 32 byte line size */
+	{ 0x86, LVL_2,      512 },	/* 4-way set assoc, 64 byte line size */
+	{ 0x87, LVL_2,      MB(1) },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd0, LVL_3,      512 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd1, LVL_3,      MB(1) },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd2, LVL_3,      MB(2) },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd6, LVL_3,      MB(1) },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd7, LVL_3,      MB(2) },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd8, LVL_3,      MB(4) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdc, LVL_3,      MB(2) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdd, LVL_3,      MB(4) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xde, LVL_3,      MB(8) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xe2, LVL_3,      MB(2) },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe3, LVL_3,      MB(4) },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe4, LVL_3,      MB(8) },	/* 16-way set assoc, 64 byte line size */
+	{ 0xea, LVL_3,      MB(12) },	/* 24-way set assoc, 64 byte line size */
+	{ 0xeb, LVL_3,      MB(18) },	/* 24-way set assoc, 64 byte line size */
+	{ 0xec, LVL_3,      MB(24) },	/* 24-way set assoc, 64 byte line size */
 	{ 0x00, 0, 0}
 };
 

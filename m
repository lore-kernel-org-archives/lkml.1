Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbYDQEBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbYDQEBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbYDQEBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:01:25 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:48455 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYDQEBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:01:25 -0400
Message-ID: <4806CB92.6010402@tiscali.nl>
Date: Thu, 17 Apr 2008 06:01:22 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] SH: catch negative denormal_subf1() retval in denormal_add()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'ix' is unsigned but denormal_subf1() may return a negative int.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/sh/kernel/cpu/sh2a/fpu.c b/arch/sh/kernel/cpu/sh2a/fpu.c
index 5627c0b..6df2fb9 100644
--- a/arch/sh/kernel/cpu/sh2a/fpu.c
+++ b/arch/sh/kernel/cpu/sh2a/fpu.c
@@ -300,7 +300,7 @@ static int denormal_addf(int hx, int hy)
 		iy = hy & 0x7fffffff;
 		if (iy < 0x00800000) {
 			ix = denormal_subf1(ix, iy);
-			if (ix < 0) {
+			if ((int) ix < 0) {
 				ix = -ix;
 				sign ^= 0x80000000;
 			}
@@ -385,7 +385,7 @@ static long long denormal_addd(long long hx, long long hy)
 		iy = hy & 0x7fffffffffffffffLL;
 		if (iy < 0x0010000000000000LL) {
 			ix = denormal_subd1(ix, iy);
-			if (ix < 0) {
+			if ((int) ix < 0) {
 				ix = -ix;
 				sign ^= 0x8000000000000000LL;
 			}

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYGaGFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYGaGFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 02:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYGaGFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 02:05:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:41013 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbYGaGFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:05:35 -0400
Subject: mm/hugetlb: Don't crash when HPAGE_SHIFT is 0
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: linux-mm <linux-mm@kvack.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 31 Jul 2008 16:04:28 +1000
Message-Id: <1217484268.11188.419.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platform decide whether they support huge pages at boot
time. On these, such as powerpc, HPAGE_SHIFT is a variable, not
a constant, and is set to 0 when there is no such support.

The patches to introduce multiple huge pages support broke that
causing the kernel to crash at boot time on machines such as
POWER3 which lack support for multiple page sizes.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Please apply upstream ASAP.

﻿(resent with more useful mailing list address)

Index: linux-work/mm/hugetlb.c
===================================================================
--- linux-work.orig/mm/hugetlb.c	2008-07-31 15:28:03.000000000 +1000
+++ linux-work/mm/hugetlb.c	2008-07-31 15:31:29.000000000 +1000
@@ -1283,7 +1283,12 @@ module_exit(hugetlb_exit);
 
 static int __init hugetlb_init(void)
 {
-	BUILD_BUG_ON(HPAGE_SHIFT == 0);
+	/* Some platform decide whether they support huge pages at boot
+	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
+	 * there is no such support
+	 */
+	if (HPAGE_SHIFT == 0)
+		return 0;
 
 	if (!size_to_hstate(default_hstate_size)) {
 		default_hstate_size = HPAGE_SIZE;



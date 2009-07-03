Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZGCSOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZGCSOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbZGCSOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:14:36 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:59441 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbZGCSOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:14:35 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Fri, 3 Jul 2009 13:14:30 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031314.36243.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is one I have found useful in my VIA processor bug hunting:

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 3068388..2303d86 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -61,7 +61,7 @@

 /* Enough space to fit pagetables for the low memory linear map */
 MAPPING_BEYOND_END = \
-       PAGE_TABLE_SIZE(((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
+       PAGE_TABLE_SIZE((1<<20) - (__PAGE_OFFSET >> PAGE_SHIFT)) << PAGE_SHIFT

 /*
  * Worst-case size of the kernel mapping we need to make:

= = =

Before:

  #5 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
  #6 [0000011000 - 0000015000]          BOOTMAP ==> [0000011000 - 0000015000]

After:

  #5 [0000010000 - 000007d000]          PGTABLE ==> [0000010000 - 000007d000]
  #6 [000007d000 - 0000081000]          BOOTMAP ==> [000007d000 - 0000081000]

Someone who knows mm check which is the reasonable value please.

Mike

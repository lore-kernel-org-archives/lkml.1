Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbZJ1LEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZJ1LEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 07:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZJ1LEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 07:04:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39621 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752135AbZJ1LEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 07:04:12 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] edac: i7core_edac produces undefined behaviour on 32bit
To: dougthompson@xmission.com, mchehab@redhat.com,
       linux-kernel@vger.kernel.org
Date: Wed, 28 Oct 2009 10:52:00 +0000
Message-ID: <20091028105200.6097.58279.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the shifts up

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/edac/i7core_edac.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index b6fce2e..bd7c727 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -916,41 +916,41 @@ static ssize_t i7core_inject_enable_store(struct mem_ctl_info *mci,
 
 	/* Sets pvt->inject.dimm mask */
 	if (pvt->inject.dimm < 0)
-		mask |= 1L << 41;
+		mask |= 1LL << 41;
 	else {
 		if (pvt->channel[pvt->inject.channel].dimms > 2)
-			mask |= (pvt->inject.dimm & 0x3L) << 35;
+			mask |= (pvt->inject.dimm & 0x3LL) << 35;
 		else
-			mask |= (pvt->inject.dimm & 0x1L) << 36;
+			mask |= (pvt->inject.dimm & 0x1LL) << 36;
 	}
 
 	/* Sets pvt->inject.rank mask */
 	if (pvt->inject.rank < 0)
-		mask |= 1L << 40;
+		mask |= 1LL << 40;
 	else {
 		if (pvt->channel[pvt->inject.channel].dimms > 2)
-			mask |= (pvt->inject.rank & 0x1L) << 34;
+			mask |= (pvt->inject.rank & 0x1LL) << 34;
 		else
-			mask |= (pvt->inject.rank & 0x3L) << 34;
+			mask |= (pvt->inject.rank & 0x3LL) << 34;
 	}
 
 	/* Sets pvt->inject.bank mask */
 	if (pvt->inject.bank < 0)
-		mask |= 1L << 39;
+		mask |= 1LL << 39;
 	else
-		mask |= (pvt->inject.bank & 0x15L) << 30;
+		mask |= (pvt->inject.bank & 0x15LL) << 30;
 
 	/* Sets pvt->inject.page mask */
 	if (pvt->inject.page < 0)
-		mask |= 1L << 38;
+		mask |= 1LL << 38;
 	else
-		mask |= (pvt->inject.page & 0xffffL) << 14;
+		mask |= (pvt->inject.page & 0xffff) << 14;
 
 	/* Sets pvt->inject.column mask */
 	if (pvt->inject.col < 0)
-		mask |= 1L << 37;
+		mask |= 1LL << 37;
 	else
-		mask |= (pvt->inject.col & 0x3fffL);
+		mask |= (pvt->inject.col & 0x3fff);
 
 	/*
 	 * bit    0: REPEAT_EN


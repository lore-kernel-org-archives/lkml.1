Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbZJLOuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbZJLOuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932401AbZJLOuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:50:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59154 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932405AbZJLOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:50:17 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] et131x: Fix the add_10bit macro
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 12 Oct 2009 15:38:26 +0100
Message-ID: <20091012143823.20944.3745.stgit@localhost.localdomain>
In-Reply-To: <20091012142816.20944.92471.stgit@localhost.localdomain>
References: <20091012142816.20944.92471.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duh.. we need to preserve the wrap bit when adding.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/et131x/et1310_address_map.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/et131x/et1310_address_map.h b/drivers/staging/et131x/et1310_address_map.h
index 6294d38..2c3d65a 100644
--- a/drivers/staging/et131x/et1310_address_map.h
+++ b/drivers/staging/et131x/et1310_address_map.h
@@ -223,7 +223,7 @@ typedef union _TXDMA_PR_NUM_DES_t {
 
 extern inline void add_10bit(u32 *v, int n)
 {
-	*v = INDEX10(*v + n);
+	*v = INDEX10(*v + n) | (*v & ET_DMA10_WRAP);
 }
 
 /*


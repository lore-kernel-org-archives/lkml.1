Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYJPSNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYJPSNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYJPSNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:13:11 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:14066 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752123AbYJPSNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:13:10 -0400
Date: Thu, 16 Oct 2008 12:13:08 -0600
From: dougthompson@xmission.com
To: benh@kernel.crashing.org, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/1] edac cell: fix incorrect edac_mode
Message-ID: <48f78434.Hj5aU4wgiL/VVJvn%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The cell_edac driver is setting the edac_mode field of the
csrow's to an incorrect value, causing the sysfs show routine
for that field to go out of an array bound and Oopsing the kernel
when used.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---

 drivers/edac/cell_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-work.orig/drivers/edac/cell_edac.c	2008-10-15 15:35:21.000000000 +1100
+++ linux-work/drivers/edac/cell_edac.c	2008-10-15 15:35:29.000000000 +1100
@@ -142,7 +142,7 @@ static void __devinit cell_edac_init_csr
 		csrow->nr_pages = (r.end - r.start + 1) >> PAGE_SHIFT;
 		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
 		csrow->mtype = MEM_XDR;
-		csrow->edac_mode = EDAC_FLAG_EC | EDAC_FLAG_SECDED;
+		csrow->edac_mode = EDAC_SECDED;
 		dev_dbg(mci->dev,
 			"Initialized on node %d, chanmask=0x%x,"
 			" first_page=0x%lx, nr_pages=0x%x\n",


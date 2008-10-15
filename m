Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbYJOElP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbYJOElP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 00:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYJOEk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 00:40:59 -0400
Received: from ozlabs.org ([203.10.76.45]:39514 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYJOEk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 00:40:59 -0400
To: <dougthompson@xmission.com>
CC: <linuxppc-dev@ozlabs.org>, <mniyer@us.ibm.com>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 15 Oct 2008 15:40:19 +1100
Subject: [PATCH] edac/cell: Fix incorrect edac_mode in csrow causing oops
Message-Id: <20081015044057.584D6DDDFB@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cell_edac driver is setting the edac_mode field of the
csrow's to an incorrect value, causing the sysfs show routine
for that field to go out of an array bound and Oopsing the kernel
when used.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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

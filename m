Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYFISq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYFISq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYFISqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:46:51 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33218 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbYFISqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:46:50 -0400
Date: Mon, 9 Jun 2008 13:46:49 -0500
From: scameron@beardog.cca.cpqcorp.net
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: mikem@beardog.cca.cpqcorp.net, scameron@beardog.cca.cpqcorp.net
Subject: [patch] cciss: Fix regression that no device nodes are created if no logical drives are configured.
Message-ID: <20080609184649.GV8065@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Fix regression in cciss driver that if no logical drives are configured,
no device nodes at all get created.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

---

 drivers/block/cciss.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/block/cciss.c~cciss_fix_cxd0_missing_if_no_drives drivers/block/cciss.c
--- linux-2.6.26rc5/drivers/block/cciss.c~cciss_fix_cxd0_missing_if_no_drives	2008-06-09 09:27:37.000000000 -0500
+++ linux-2.6.26rc5-root/drivers/block/cciss.c	2008-06-09 12:33:07.000000000 -0500
@@ -3535,6 +3535,10 @@ static int __devinit cciss_init_one(stru
 	for (j = 0; j <= hba[i]->highest_lun; j++)
 		add_disk(hba[i]->gendisk[j]);
 
+	/* we must register the controller even if no disks exist */
+	if (hba[i]->highest_lun == -1)
+		add_disk(hba[i]->gendisk[0]);
+
 	return 1;
 
       clean4:
_

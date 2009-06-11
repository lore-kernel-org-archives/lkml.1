Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbZFKNOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbZFKNOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZFKNOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:14:40 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:42527 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZFKNOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:14:39 -0400
Date: Thu, 11 Jun 2009 15:14:40 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] partitions: fix broken uevent_suppress conversion
Message-ID: <20090611131440.GA3146@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

git commit f67f129e "Driver core: implement uevent suppress in kobject"
contains this chunk for fs/partitions/check.c:

 	/* suppress uevent if the disk supresses it */
-	if (!ddev->uevent_suppress)
+	if (!dev_get_uevent_suppress(pdev))
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);

However that should have been

-	if (!ddev->uevent_suppress)
+	if (!dev_get_uevent_suppress(ddev))

Cc: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/partitions/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/partitions/check.c
===================================================================
--- linux-2.6.orig/fs/partitions/check.c
+++ linux-2.6/fs/partitions/check.c
@@ -426,7 +426,7 @@ struct hd_struct *add_partition(struct g
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
-	if (!dev_get_uevent_suppress(pdev))
+	if (!dev_get_uevent_suppress(ddev))
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);
 
 	return p;

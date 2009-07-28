Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbZG1X6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbZG1X6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbZG1X6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:58:47 -0400
Received: from kroah.org ([198.145.64.141]:35752 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277AbZG1Xt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:55 2009
Message-Id: <20090728234155.471526594@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>
Subject: [patch 28/71] partitions: fix broken uevent_suppress conversion
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=partitions-fix-broken-uevent_suppress-conversion.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit f8c73c790c588fd70fda1632c8927a87b3d31dcd upstream.

git commit f67f129e "Driver core: implement uevent suppress in kobject"
contains this chunk for fs/partitions/check.c:

 	/* suppress uevent if the disk supresses it */
-	if (!ddev->uevent_suppress)
+	if (!dev_get_uevent_suppress(pdev))
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);

However that should have been

-	if (!ddev->uevent_suppress)
+	if (!dev_get_uevent_suppress(ddev))

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/partitions/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -426,7 +426,7 @@ struct hd_struct *add_partition(struct g
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
-	if (!dev_get_uevent_suppress(pdev))
+	if (!dev_get_uevent_suppress(ddev))
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);
 
 	return p;



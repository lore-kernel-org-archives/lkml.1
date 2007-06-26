Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbXFZTHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbXFZTHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759539AbXFZTFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:05:46 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25148 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759506AbXFZTFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:05:42 -0400
Message-Id: <b21709fe9108128c75c78a29597d5fc3d19049ba.1182883861.git.ecashin@coraid.com>
In-Reply-To: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
From: "Ed L. Cashin" <ecashin@coraid.com>
Date: Tue, 26 Jun 2007 14:50:12 -0400
Subject: [PATCH 08/12] only schedule work once
To: linux-kernel@vger.kernel.org
Cc: Greg K-H <greg@kroah.com>, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Only schedule work once.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 89df9de..8d6540b 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -681,6 +681,8 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 			d->fw_ver, (long long)ssize);
 	d->ssize = ssize;
 	d->geo.start = 0;
+	if (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
+		return;
 	if (d->gd != NULL) {
 		d->gd->capacity = ssize;
 		d->flags |= DEVFL_NEWSIZE;
-- 
1.5.2.1


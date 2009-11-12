Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbZKLAZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbZKLAZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 19:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759798AbZKLAZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 19:25:29 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:15799 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759834AbZKLAZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 19:25:12 -0500
Subject: [PATCH 2/2] hpsa: make device attrs static
To: akpm@linux-foundation.org, jens.axboe@oracle.com
From: Alex Chiang <achiang@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Mike Miller <mikem@beardog.cce.hp.com>, linux-kernel@vger.kernel.org,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Date: Wed, 11 Nov 2009 17:25:17 -0700
Message-ID: <20091112002517.5660.74298.stgit@bob.kio>
In-Reply-To: <20091112001933.5660.10843.stgit@bob.kio>
References: <20091112001933.5660.10843.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to export those device attributes.

In fact, without this patch, we can trip over a build error if hpsa
is a built-in and another driver also declares and exports attributes
with the same name.

You'll see errors like:

	drivers/scsi/built-in.o: multiple definition of `dev_attr_lunid'
	drivers/block/built-in.o: first defined here

Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/scsi/hpsa.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e402155..aae5f5a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -146,11 +146,11 @@ static ssize_t lunid_show(struct device *dev,
 static ssize_t unique_id_show(struct device *dev,
 	struct device_attribute *attr, char *buf);
 
-DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
-DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
-DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
+static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
+static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
+static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
 
-struct device_attribute *hpsa_sdev_attrs[] = {
+static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
 	&dev_attr_lunid,
 	&dev_attr_unique_id,


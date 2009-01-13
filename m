Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbZAMVkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbZAMVkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZAMVk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:40:27 -0500
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:53363 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbZAMVk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:40:26 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Chris Mason <chris.mason@oracle.com>
Subject: [RFC][PATCH] btrfs: missing initialization while adding extent
Date: Tue, 13 Jan 2009 22:41:48 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901132241.49268.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we race while adding an extent and successful look it
of afterwards, we don't set the em->bdev. Now we do :-)


Signed-off-by: Ingo Oeser <ioe-lkml@rameria.de>
---
 fs/btrfs/disk-io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 81a3138..25a0d15 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -118,6 +118,7 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 		free_extent_map(em);
 		em = lookup_extent_mapping(em_tree, start, len);
 		if (em) {
+			em->bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 			ret = 0;
 		} else {
 			em = lookup_extent_mapping(em_tree, failed_start,
-- 
1.5.6.3


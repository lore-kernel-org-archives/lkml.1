Return-Path: <linux-kernel-owner+w=401wt.eu-S1764260AbYBMDxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764260AbYBMDxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 22:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759470AbYBMDxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 22:53:04 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56860 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYBMDxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 22:53:01 -0500
Date: Wed, 13 Feb 2008 03:53:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, agk@redhat.com
Subject: [PATCH] dm-raid1 breakage on 64bit
Message-ID: <20080213035300.GP27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

test_and_set_bit() on address of uint32_t is a Bad Idea(tm)...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index edc057f..2928ef2 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -124,7 +124,7 @@ enum dm_raid1_error {
 struct mirror {
 	struct mirror_set *ms;
 	atomic_t error_count;
-	uint32_t error_type;
+	unsigned long error_type;
 	struct dm_dev *dev;
 	sector_t offset;
 };

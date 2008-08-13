Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbYHMIjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbYHMIjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYHMIjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:19 -0400
Received: from smtp.nokia.com ([192.100.105.134]:31846 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbYHMIjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:18 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: print volume name as well
Date: Wed, 13 Aug 2008 13:17:31 +0300
Message-Id: <1218622675-28853-3-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0128 (UTC) FILETIME=[0A28B580:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

We encouredge people to mount using volume name, not device
numbers. So print the name of the mounted UBI volume, not just
IDs.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index ca1e2d4..43af934 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1122,8 +1122,8 @@ static int mount_ubifs(struct ubifs_info *c)
 	if (err)
 		goto out_infos;
 
-	ubifs_msg("mounted UBI device %d, volume %d", c->vi.ubi_num,
-		  c->vi.vol_id);
+	ubifs_msg("mounted UBI device %d, volume %d, name \"%s\"",
+		  c->vi.ubi_num, c->vi.vol_id, c->vi.name);
 	if (mounted_read_only)
 		ubifs_msg("mounted read-only");
 	x = (long long)c->main_lebs * c->leb_size;
-- 
1.5.4.1


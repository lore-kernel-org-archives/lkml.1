Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbYHaNSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbYHaNSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbYHaNPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:15:31 -0400
Received: from smtp.nokia.com ([192.100.105.134]:44083 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759741AbYHaNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:15:30 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: [PATCH] UBIFS: fill f_fsid
Date: Sun, 31 Aug 2008 17:52:46 +0300
Message-Id: <1220194366-12731-13-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 31 Aug 2008 13:14:26.0134 (UTC) FILETIME=[7E12D760:01C90B6B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

UBIFS stores 16-bit UUID in the superblock, and it is a good
idea to return part of it in 'f_fsid' filed of kstatfs structure.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 1207bd5..0dee404 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -386,6 +386,7 @@ static int ubifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = 0;
 	buf->f_ffree = 0;
 	buf->f_namelen = UBIFS_MAX_NLEN;
+	memcpy(&buf->f_fsid, c->uuid, sizeof(__kernel_fsid_t));
 
 	return 0;
 }
-- 
1.5.4.1


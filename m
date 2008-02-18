Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbYBRUw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbYBRUw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760891AbYBRUwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:52:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:16065 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760771AbYBRUwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:52:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Oy24SzhW48q5rFgcjplZrMnlpeLRXdxKIzbYKkYDFOpBchYkhyOngolGn2zrJILcXhhkXVFF+8vV7SC15ujjPdUBAvJHf3EBvuzCAOQNrL9VYQ6pL1mc2Pl2ThLVEH762Xq58mdSBRbb8N8cSmLbX28mwn7Fz5ZRFhSR9f+1f88=
Subject: [PATCH 3/6] reiserfs: fix sparse warning in namei.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 12:52:41 -0800
Message-Id: <1203367961.5757.63.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/reiserfs/namei.c:455:17: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/reiserfs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index b378eea..8867533 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -452,7 +452,7 @@ static int reiserfs_add_entry(struct reiserfs_transaction_handle *th,
 	buflen = DEH_SIZE + ROUND_UP(namelen);
 	if (buflen > sizeof(small_buf)) {
 		buffer = kmalloc(buflen, GFP_NOFS);
-		if (buffer == 0)
+		if (!buffer)
 			return -ENOMEM;
 	} else
 		buffer = small_buf;
-- 
1.5.4.1.1278.gc75be



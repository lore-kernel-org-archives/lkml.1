Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZCJFSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZCJFSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZCJFMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:12:10 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:53984 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZCJFMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WSitISO9CF/p2wFmGvXXlO04fnZAU/eF6eah3tk/TnnI5EEOSvCZHLcV0Z1BPHvGgH
         0iSri12zqYYqSJ1IdtfhFwflS45T7u4yu/jIM/uRIyi0ogA/g1iEW2/AizR7kmM1+dQ9
         2Zb2WPhOMLVKzNMIRR6VOeDi1Sg/7KSaqjnY0=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, reiserfs-devel@vger.kernel.org
Subject: [PATCH 22/25] [reiserfs] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:47 -0500
Message-Id: <1236661850-8237-23-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-22-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-17-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-18-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-19-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-20-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-21-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-22-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 include/linux/reiserfs_fs.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index bc5114d..67a38f5 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -1707,8 +1707,7 @@ static inline int reiserfs_transaction_running(struct super_block *s)
 	struct reiserfs_transaction_handle *th = current->journal_info;
 	if (th && th->t_super == s)
 		return 1;
-	if (th && th->t_super == NULL)
-		BUG();
+	BUG_ON(th && th->t_super == NULL);
 	return 0;
 }
 
-- 
1.6.1.3


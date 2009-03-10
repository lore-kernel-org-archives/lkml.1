Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZCJFTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZCJFTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZCJFMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:12:12 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:28373 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbZCJFMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:12:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lUgWqYF2a4D7SWgDnzbbePjt3LE9TeWzwXGq/GxmppRAYkQNdlrST7evMxrufq2q48
         zOh5mv6HLLPhnhW0NDHtT/wRVr0IpPlNwMyD7YN41DGNMvMKWxKnban68+RZavT+XbqT
         lJy3ciBjE7uBamMFnSeDne/pYcxpU+0eKAr4w=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: [PATCH 23/25] [drivers/misc] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:48 -0500
Message-Id: <1236661850-8237-24-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-23-git-send-email-stoyboyker@gmail.com>
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
 <1236661850-8237-23-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/misc/sgi-gru/grukservices.c |    3 +--
 drivers/misc/sgi-gru/grumain.c      |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
index 880c55d..a942b33 100644
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -603,8 +603,7 @@ static int quicktest(struct gru_state *gru)
 	if (gru_wait(cb) != CBS_IDLE)
 		BUG();
 
-	if (*(unsigned long *)ds != MAGIC)
-		BUG();
+	BUG_ON(*(unsigned long *)ds != MAGIC);
 	gru_vstore(cb, uv_gpa(&word1), 0, XTYPE_DW, 1, 1, IMA);
 	if (gru_wait(cb) != CBS_IDLE)
 		BUG();
diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
index 3d2fc21..65df0f6 100644
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -153,8 +153,7 @@ static unsigned long reserve_resources(unsigned long *p, int n, int mmax,
 
 	do {
 		i = find_first_bit(p, mmax);
-		if (i == mmax)
-			BUG();
+		BUG_ON(i == mmax);
 		__clear_bit(i, p);
 		__set_bit(i, &bits);
 		if (idx)
-- 
1.6.1.3


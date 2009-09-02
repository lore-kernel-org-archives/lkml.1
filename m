Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbZIBPkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbZIBPkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 11:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZIBPkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 11:40:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37512 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZIBPko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 11:40:44 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 1/1] IMA: open new file for read
Date: Wed,  2 Sep 2009 11:40:32 -0400
Message-Id: <66fbda5f63fbb20bfccf6fd3f8006718f7994ec6.1251901838.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When creating a new file, ima_path_check() assumed the new file
was being opened for write. Call ima_path_check() with the
appropriate acc_mode so that the read/write counters are
incremented correctly.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 fs/namei.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f3c5b27..ee01308 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1533,9 +1533,11 @@ int may_open(struct path *path, int acc_mode, int flag)
 	if (error)
 		return error;
 
-	error = ima_path_check(path,
-			       acc_mode & (MAY_READ | MAY_WRITE | MAY_EXEC),
+	error = ima_path_check(path, acc_mode ?
+			       acc_mode & (MAY_READ | MAY_WRITE | MAY_EXEC) :
+			       ACC_MODE(flag) & (MAY_READ | MAY_WRITE),
 			       IMA_COUNT_UPDATE);
+
 	if (error)
 		return error;
 	/*
-- 
1.6.0.6


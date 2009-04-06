Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZDFMs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZDFMs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZDFMsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:48:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50476 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbZDFMsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:48:14 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, torvalds@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/8] Add WRITE_SYNC_PLUG and SWRITE_SYNC_PLUG
Date: Mon,  6 Apr 2009 14:48:02 +0200
Message-Id: <1239022088-29002-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.1.423.g442d
In-Reply-To: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(S)WRITE_SYNC always unplugs the device right after IO submission.
Sometimes we want to build up a queue before doing so, so add
variants that explicitly DON'T unplug the queue. The caller must
then do that after submitting all the IO.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/fs.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a09e17c..ea05109 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -96,7 +96,10 @@ struct inodes_stat_t {
 #define READ_SYNC	(READ | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define READ_META	(READ | (1 << BIO_RW_META))
 #define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
+#define WRITE_SYNC_PLUG	(WRITE | (1 << BIO_RW_SYNCIO))
 #define SWRITE_SYNC	(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
+#define SWRITE_SYNC_PLUG	\
+	(SWRITE | (1 << BIO_RW_SYNCIO))
 #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
 #define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)
 #define DISCARD_BARRIER ((1 << BIO_RW_DISCARD) | (1 << BIO_RW_BARRIER))
-- 
1.6.2.1.423.g442d


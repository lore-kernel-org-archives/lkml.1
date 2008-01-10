Return-Path: <linux-kernel-owner+w=401wt.eu-S1759978AbYAJWLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbYAJWLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758372AbYAJWLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:11:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:45356 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbYAJWLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:11:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Hdxx9HD14N5Xbbt242Dqe26tNhLUzOn1pkgC3AIrMGcUkJQtGb2EU7JTuEA1FrAqWCxoCT9jAlHkYhcvNHCyAKSewdHBwIq1YWaDsr8VLkH1g73gEZ3inXYgQrC5XtJuGybs2dJG9BEonnvou2A6USQZu4wdFd7AyrVDweZg2iU=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 15/16] udf: fix udf_debug macro
Date: Thu, 10 Jan 2008 23:06:31 +0100
Message-Id: <1200002792-8449-16-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

udf_debug should be enclosed with do { } while (0)
to be safely used in code like below:
if (something)
	udf_debug();
else
	anything;
(Otherwise compiler will not compile it with:
"error: expected expression before 'else'")

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Jan Kara <jack@suse.cz>
---
 include/linux/udf_fs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/udf_fs.h b/include/linux/udf_fs.h
index 36c684e..c954527 100644
--- a/include/linux/udf_fs.h
+++ b/include/linux/udf_fs.h
@@ -39,11 +39,11 @@
 
 #ifdef UDFFS_DEBUG
 #define udf_debug(f, a...) \
-	{ \
+	do { \
 		printk (KERN_DEBUG "UDF-fs DEBUG %s:%d:%s: ", \
 			__FILE__, __LINE__, __FUNCTION__); \
 		printk (f, ##a); \
-	}
+	} while (0)
 #else
 #define udf_debug(f, a...) /**/
 #endif
-- 
1.5.3.7


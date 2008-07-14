Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYGNWEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYGNWEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbYGNWCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:02:09 -0400
Received: from mx1.suse.de ([195.135.220.2]:49941 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034AbYGNWCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:02:08 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>
Subject: [PATCH 07/17] ocfs2/net: Silence build warnings on sparc64
Date: Mon, 14 Jul 2008 15:01:40 -0700
Message-Id: <1216072910-27226-8-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

suseconds_t is type long on most arches except sparc64 where it is type int.
This patch silences the following warnings that are generated when building
on it.

netdebug.c: In function 'nst_seq_show':
netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 13 has type 'suseconds_t'
netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 15 has type 'suseconds_t'
netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 17 has type 'suseconds_t'
netdebug.c: In function 'sc_seq_show':
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 19 has type 'suseconds_t'
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 21 has type 'suseconds_t'
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 23 has type 'suseconds_t'
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 25 has type 'suseconds_t'
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 27 has type 'suseconds_t'
netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 29 has type 'suseconds_t'

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/cluster/netdebug.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 7bf3c0e..d8bfa0e 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -146,8 +146,10 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 			   nst->st_task->comm, nst->st_node,
 			   nst->st_sc, nst->st_id, nst->st_msg_type,
 			   nst->st_msg_key,
-			   nst->st_sock_time.tv_sec, nst->st_sock_time.tv_usec,
-			   nst->st_send_time.tv_sec, nst->st_send_time.tv_usec,
+			   nst->st_sock_time.tv_sec,
+			   (unsigned long)nst->st_sock_time.tv_usec,
+			   nst->st_send_time.tv_sec,
+			   (unsigned long)nst->st_send_time.tv_usec,
 			   nst->st_status_time.tv_sec,
 			   nst->st_status_time.tv_usec);
 	}
@@ -274,7 +276,7 @@ static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	return sc; /* unused, just needs to be null when done */
 }
 
-#define TV_SEC_USEC(TV) TV.tv_sec, TV.tv_usec
+#define TV_SEC_USEC(TV) TV.tv_sec, (unsigned long)TV.tv_usec
 
 static int sc_seq_show(struct seq_file *seq, void *v)
 {
-- 
1.5.4.1


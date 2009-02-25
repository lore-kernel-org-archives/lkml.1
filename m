Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbZBYUcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbZBYUcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760609AbZBYUbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:31:46 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52215 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760525AbZBYUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:31:45 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 2/8] 9p: fix sparse warning: cast adds address space
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 21:31:37 +0100
Message-ID: <20090225203132.6251.63332.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090225203012.6251.32002.stgit@vmbox.hanneseder.net>
References: <20090225203012.6251.32002.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Trust in the comment and add '__force' to the cast.

Fix this sparse warning:
  net/9p/trans_fd.c:420:34: warning: cast adds address space to expression (<asn:1>)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 net/9p/trans_fd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 1df0356..c613ed0 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -417,7 +417,7 @@ static int p9_fd_write(struct p9_client *client, void *v, int len)
 	oldfs = get_fs();
 	set_fs(get_ds());
 	/* The cast to a user pointer is valid due to the set_fs() */
-	ret = vfs_write(ts->wr, (void __user *)v, len, &ts->wr->f_pos);
+	ret = vfs_write(ts->wr, (__force void __user *)v, len, &ts->wr->f_pos);
 	set_fs(oldfs);
 
 	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)


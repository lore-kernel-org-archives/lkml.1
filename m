Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbXLRQxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbXLRQxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 11:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbXLRQxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 11:53:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758039AbXLRQxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 11:53:08 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org
Subject: [PATCH 5/7] NLM: Have lockd call try_to_freeze
Date: Tue, 18 Dec 2007 11:42:37 -0500
Message-Id: <1197996159-20799-6-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1197996159-20799-5-git-send-email-jlayton@redhat.com>
References: <1197996159-20799-1-git-send-email-jlayton@redhat.com>
 <1197996159-20799-2-git-send-email-jlayton@redhat.com>
 <1197996159-20799-3-git-send-email-jlayton@redhat.com>
 <1197996159-20799-4-git-send-email-jlayton@redhat.com>
 <1197996159-20799-5-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockd makes itself freezable, but never calls try_to_freeze(). Have it
call try_to_freeze() within the main loop.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/lockd/svc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 0f4148a..03a83a0 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -155,6 +155,9 @@ lockd(struct svc_rqst *rqstp)
 		long timeout = MAX_SCHEDULE_TIMEOUT;
 		char buf[RPC_MAX_ADDRBUFLEN];
 
+		if (try_to_freeze())
+			continue;
+
 		if (signalled()) {
 			flush_signals(current);
 			if (nlmsvc_ops) {
-- 
1.5.3.3


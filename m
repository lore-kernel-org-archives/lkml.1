Return-Path: <linux-kernel-owner+w=401wt.eu-S932633AbXLMUmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbXLMUmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932225AbXLMUki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:40:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730AbXLMUkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:40:31 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org
Subject: [PATCH 4/6] NLM: Have lockd call try_to_freeze
Date: Thu, 13 Dec 2007 15:40:26 -0500
Message-Id: <1197578428-26815-5-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1197578428-26815-4-git-send-email-jlayton@redhat.com>
References: <1197578428-26815-1-git-send-email-jlayton@redhat.com>
 <1197578428-26815-2-git-send-email-jlayton@redhat.com>
 <1197578428-26815-3-git-send-email-jlayton@redhat.com>
 <1197578428-26815-4-git-send-email-jlayton@redhat.com>
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


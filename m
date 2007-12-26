Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbXLZDFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbXLZDFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 22:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbXLZDFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 22:05:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:31266 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbXLZDFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 22:05:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=aag9wtQGBlR8dGwWnqBUrCzP3jy4lEaGDR8OxVHRrf0FBikEBaKDOBHxIzlwH/qm22UJK/EVHZ0vwlL7lcHM93aelGNwJZHsP46BoRDWbw3+pYyYsbZF1ulOXdf9pgYO0ZA9stNf+iBVj/0CKHaq4Xlx2NZ6I4aIYpMJIBAGjEw=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: <pcaulfie@redhat.com>, <teigland@redhat.com>
Subject: [PATCH 1/2] fs/dlm: get rid of unnecessary initialization
Date: Wed, 26 Dec 2007 12:04:34 +0900
Message-ID: <000301c8476c$20eafbd0$47e7a8c0@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AchHajrc/ie8FduGSY2qPMF85iMH/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

default_groups was allocated with kcalloc, so initialization to NULL is unnecessary.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 fs/dlm/config.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 2f8e3c8..95085d1 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -414,7 +414,6 @@ static struct config_group *make_cluster(struct config_group *g,
 	cl->group.default_groups = gps;
 	cl->group.default_groups[0] = &sps->ss_group;
 	cl->group.default_groups[1] = &cms->cs_group;
-	cl->group.default_groups[2] = NULL;
 
 	cl->cl_tcp_port = dlm_config.ci_tcp_port;
 	cl->cl_buffer_size = dlm_config.ci_buffer_size;
@@ -483,7 +482,6 @@ static struct config_group *make_space(struct config_group *g, const char *name)
 
 	sp->group.default_groups = gps;
 	sp->group.default_groups[0] = &nds->ns_group;
-	sp->group.default_groups[1] = NULL;
 
 	INIT_LIST_HEAD(&sp->members);
 	mutex_init(&sp->members_lock);
---

Thanks.
Joonwoo


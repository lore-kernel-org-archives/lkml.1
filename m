Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYAEME3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYAEME3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 07:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbYAEMDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 07:03:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbYAEMDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 07:03:00 -0500
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] NLM: Initialize completion variable in lockd_up
Date: Sat,  5 Jan 2008 07:02:19 -0500
Message-Id: <1199534542-3384-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199534542-3384-3-git-send-email-jlayton@redhat.com>
References: <1199534542-3384-1-git-send-email-jlayton@redhat.com>
 <1199534542-3384-2-git-send-email-jlayton@redhat.com>
 <1199534542-3384-3-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockd_start_done is a global var that can be reused if lockd is
restarted, but it's never reinitialized. On all but the first use,
wait_for_completion isn't actually waiting on it since it has
already completed once.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/lockd/svc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 82e2192..0f4148a 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -300,6 +300,7 @@ lockd_up(int proto) /* Maybe add a 'family' option when IPv6 is supported ?? */
 	/*
 	 * Create the kernel thread and wait for it to start.
 	 */
+	init_completion(&lockd_start_done);
 	error = svc_create_thread(lockd, serv);
 	if (error) {
 		printk(KERN_WARNING
-- 
1.5.3.6


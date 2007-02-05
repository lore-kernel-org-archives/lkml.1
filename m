Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXBEOJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXBEOJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932774AbXBEOJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:09:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735AbXBEOJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:09:51 -0500
Subject: [DLM] fs/dlm/lowcomms-tcp.c: remove 2 functions [8/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Patrick Caulfield <pcaulfie@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Adrian Bunk <bunk@stusta.de>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:15:50 +0000
Message-Id: <1170684950.11001.286.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3f2795b83b56726292c7bfd8664e6b4bff126079 Mon Sep 17 00:00:00 2001
From: Adrian Bunk <bunk@stusta.de>
Date: Tue, 19 Dec 2006 13:04:03 -0800
Subject: [PATCH] [DLM] fs/dlm/lowcomms-tcp.c: remove 2 functions

Remove the following unused functions:

- lowcomms_send_message()
- lowcomms_max_buffer_size()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index 9be3a44..3b22473 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -880,22 +880,6 @@ out:
 	return -1;
 }
 
-/* API send message call, may queue the request */
-/* N.B. This is the old interface - use the new one for new calls */
-int lowcomms_send_message(int nodeid, char *buf, int len, gfp_t allocation)
-{
-	struct writequeue_entry *e;
-	char *b;
-
-	e = dlm_lowcomms_get_buffer(nodeid, len, allocation, &b);
-	if (e) {
-		memcpy(b, buf, len);
-		dlm_lowcomms_commit_buffer(e);
-		return 0;
-	}
-	return -ENOBUFS;
-}
-
 /* Look for activity on active sockets */
 static void process_sockets(void)
 {
@@ -1087,14 +1071,6 @@ static int daemons_start(void)
 	return 0;
 }
 
-/*
- * Return the largest buffer size we can cope with.
- */
-int lowcomms_max_buffer_size(void)
-{
-	return PAGE_CACHE_SIZE;
-}
-
 void dlm_lowcomms_stop(void)
 {
 	int i;
-- 
1.4.4.2




Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbYAXRBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbYAXRBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758308AbYAXQ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758277AbYAXQ6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:38 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Fabio M. Di Nitto" <fabbione@ubuntu.com>
Subject: [PATCH 06/19] dlm: align midcomms message buffer
Date: Thu, 24 Jan 2008 10:50:29 -0600
Message-Id: <1201193442-8260-7-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio M. Di Nitto <fabbione@ubuntu.com>

gcc does not guarantee that a static buffer is 64bit aligned. This change
allows sparc64 to work.

Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/midcomms.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index f8c69dd..da653b5 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -58,7 +58,7 @@ static void copy_from_cb(void *dst, const void *base, unsigned offset,
 int dlm_process_incoming_buffer(int nodeid, const void *base,
 				unsigned offset, unsigned len, unsigned limit)
 {
-	unsigned char __tmp[DLM_INBUF_LEN];
+	unsigned char __tmp[DLM_INBUF_LEN] __attribute__((aligned(64)));
 	struct dlm_header *msg = (struct dlm_header *) __tmp;
 	int ret = 0;
 	int err = 0;
-- 
1.5.3.3


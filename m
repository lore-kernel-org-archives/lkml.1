Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbYDRSTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbYDRSTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759578AbYDRSRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:17:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759547AbYDRSRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:17:40 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 1/6] dlm: match signedness between dlm_config_info and cluster_set
Date: Fri, 18 Apr 2008 13:12:43 -0500
Message-Id: <1208542368-13417-2-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

cluster_set is only called from the macro CLUSTER_ATTR which defines read/write
access functions.  Make the signedness match to avoid sparse warnings every time
CLUSTER_ATTR is used (lines 149-159) all of the form:

fs/dlm/config.c:149:1: warning: incorrect type in argument 3 (different signedness)
fs/dlm/config.c:149:1:    expected unsigned int *info_field
fs/dlm/config.c:149:1:    got int extern [toplevel] *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index c3ad1df..7ceaea3 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -114,7 +114,7 @@ struct cluster_attribute {
 };
 
 static ssize_t cluster_set(struct cluster *cl, unsigned int *cl_field,
-			   unsigned int *info_field, int check_zero,
+			   int *info_field, int check_zero,
 			   const char *buf, size_t len)
 {
 	unsigned int x;
-- 
1.5.3.3


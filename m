Return-Path: <linux-kernel-owner+w=401wt.eu-S933280AbYBNAzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbYBNAzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934257AbYBNAye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:54:34 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:41989 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934238AbYBNAyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:54:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rBnmewe5qBP528+hFBg8+gfZxCoyG1Bo/4U9NXvCQi9JBs5VCiEOhW+KrTc8YqMdeTy8u3PcBVtuJSFgYX9pP6AonKMIfGXqYvD0OSIfOgCHC7E6dJFiFxVe9ihv0zKRtlnTggkQ+OLIxlFcejXd7XNELqEwTZt6zVohNnuV+Mc=
Subject: [PATCH] dlm: match signedness between dlm_config_info and
	cluster_set
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Patrick Caulfield <pcaulfie@redhat.com>,
       David Teigland <teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 16:54:29 -0800
Message-Id: <1202950469.18204.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cluster_set is only called from the macro CLUSTER_ATTR which defines read/write
access functions.  Make the signedness match to avoid sparse warnings every time
CLUSTER_ATTR is used (lines 149-159) all of the form:

fs/dlm/config.c:149:1: warning: incorrect type in argument 3 (different signedness)
fs/dlm/config.c:149:1:    expected unsigned int *info_field
fs/dlm/config.c:149:1:    got int extern [toplevel] *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
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
1.5.4.1.1278.gc75be




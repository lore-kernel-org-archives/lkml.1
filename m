Return-Path: <linux-kernel-owner+w=401wt.eu-S932679AbYBTULz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbYBTULz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764756AbYBTUKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:10:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:34522 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764630AbYBTUKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:10:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C5wiBDhCo7xD4xw294eXG1KFgeQbrVv8J8aYvZVhPjmTffi97kg/fAV1oIHzJ+vbqARLKJUGoWuWFN5zLrky/ltstBo21wiKIYOPLXApVyKURFi1X8Jbjdqeu33VJzcFLGQaj4hY0XIe2MuQUzfkfV76fI5lei7gZA00QeQMi04=
Subject: [PATCH 3/4] nfs: fix sparse warning in idmap.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 12:10:47 -0800
Message-Id: <1203538247.25307.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/nfs/idmap.c:312:12: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/nfs/idmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 8ae5dba..86147b0 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -309,7 +309,7 @@ nfs_idmap_name(struct idmap *idmap, struct idmap_hashtable *h,
 	mutex_lock(&idmap->idmap_im_lock);
 
 	he = idmap_lookup_id(h, id);
-	if (he != 0) {
+	if (he) {
 		memcpy(name, he->ih_name, he->ih_namelen);
 		ret = he->ih_namelen;
 		goto out;
-- 
1.5.4.2.200.g99e75



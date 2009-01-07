Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZAGQ3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZAGQ3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZAGQ3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:29:36 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:41693 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbZAGQ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:29:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ewiv+7uYSrgyPDMxW0A0Pxpihhp45PRYtQce97DFXPBOsE0KvR5Za1xGcFsefiE/z2
         GCfdECYj1DhlkVlNwiYCYJaTHEckdYAJaOmMMjIWxs4bxVvbCIT7d6j/F8WEgIHhjFQQ
         5ifMdOYysthqt+5k8Q8gvMVbUwKDmMZ6nRkTk=
From: Bryan Wu <cooloney@kernel.org>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Graf Yang <graf.yang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] ramfs/nommu: fix bug - kernel crash when (nr != lpages)
Date: Thu,  8 Jan 2009 00:30:23 +0800
Message-Id: <1231345823-27376-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Avoiding kernel crash when (nr != lpages), and return -ENOMEM,
let the user space application handle this error.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 fs/ramfs/file-nommu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 76acdbc..9311031 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -283,7 +283,8 @@ unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 	if (pages) {
 		ptr = pages;
 		for (loop = lpages; loop > 0; loop--)
-			put_page(*ptr++);
+			if (*ptr)
+				put_page(*ptr++);
 		kfree(pages);
 	}
 
-- 
1.5.6


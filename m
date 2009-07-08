Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZGHKRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZGHKRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZGHKRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:17:46 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47514 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbZGHKRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:17:45 -0400
Subject: [PATCH] Free the memory allocated by memdup_user() in fs/sysfs/bin.c
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 08 Jul 2009 11:17:34 +0100
Message-ID: <20090708101734.27241.88930.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2009 10:17:35.0205 (UTC) FILETIME=[4FEFD150:01C9FFB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1c8542c7bb replaced kmalloc() with memdup_user() in the write()
function but also dropped the kfree(temp). The memdup_user() function
allocates memory which is never freed.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Parag Warudkar <parag.warudkar@gmail.com>
---
 fs/sysfs/bin.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 9345806..2524714 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -171,6 +171,7 @@ static ssize_t write(struct file *file, const char __user *userbuf,
 	if (count > 0)
 		*off = offs + count;
 
+	kfree(temp);
 	return count;
 }
 


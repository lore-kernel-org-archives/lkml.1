Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbYELKcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbYELKcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760901AbYELKcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:32:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:31450 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760719AbYELKcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references:sender;
        b=Huu7rU4ad/oayXWB1/Dv52QY+pfN2zkylLc1zcIStKnbOc/USzvWo1oU5pTijf3B114VLTYNwyDvu6/dkzmSFNjBecFQr0AzyYvVjvJQYqdB11BKGILmV541Fm9P5xcUxDZCmK37je95LwPXx9g8jKxE3YNIvLfypoxavxiN+C8=
From: Bryan Wu <cooloney@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/4] [NOMMU]: include the problematic mapping in the munmap warning
Date: Mon, 12 May 2008 18:32:03 +0800
Message-Id: <1210588325-11027-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 mm/nommu.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index ef8c62c..c11e5cc 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1117,8 +1117,9 @@ int do_munmap(struct mm_struct *mm, unsigned long addr, size_t len)
 			goto found;
 	}
 
-	printk("munmap of non-mmaped memory by process %d (%s): %p\n",
-	       current->pid, current->comm, (void *) addr);
+	printk(KERN_NOTICE "munmap of non-mmaped memory [%p-%p] by process %d (%s)\n",
+	       (void *)addr, (void *)addr+len, current->pid, current->comm);
+
 	return -EINVAL;
 
  found:
-- 
1.5.5


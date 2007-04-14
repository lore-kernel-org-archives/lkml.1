Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbXDNIqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbXDNIqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbXDNIqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:46:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:40189 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbXDNIqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:46:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=oEKK4cAOqNktIWPqkD07aHFquOwO5TY+B9mch1X7FYnSMFzUp9NsCK+6wUF3sjj8zCqTCcIfrsiDQCg7hGRlLBE18Q7khPMyD12e5fiWVxJWVBmjGA0i5Z55zFuTnOVZjtg2GQb8ZV7ORq0oka0jEyvWt7gzC8JzKFlde2/Al7k=
Date: Sat, 14 Apr 2007 14:18:19 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org, ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mark.fasheh@oracle.com, kurt.hackel@oracle.com
Subject: [KJ][PATCH 02/04]use set_current_state in fs
Message-ID: <20070414084819.GC14084@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


use set_current_state(TASK_*) instead of current->state = TASK_*, in fs/ocfs2

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 dlmthread.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 2b264c6..26f4474 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -76,7 +76,7 @@ repeat:
 		goto repeat;
 	}
 	remove_wait_queue(&res->wq, &wait);
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 }
 
 int __dlm_lockres_has_locks(struct dlm_lock_resource *res)
-- 
Milind Arun Choudhary

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbXITHHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbXITHHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbXITHF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:43685 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbXITHFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=MnYfiwbDgYg43wgdWpF07GyFB5Rc4bY1eOtBFeybCMqhqDb3YhhYSAiC9UgU8meUlf+xLYNx5enOIVrj69huUtoqG++jSpRs9CJZVbqS1bLCxZIz1r2t4Zkhn89fUPS14zZPWL4wolTs7mE88I+5TohYWciyAhhbHBFmpz2V74c=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 08/15] sysfs: kill unnecessary NULL pointer check in sysfs_release()
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:10 +0900
Message-Id: <11902719101962-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In sysfs_release(), sysfs_buffer pointed to by filp->private_data is
guaranteed to exist.  Kill the unnecessary NULL check.  This also
makes the code more consistent with the counterpart in fs/sysfs/bin.c.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/file.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 73333dc..8f1ebd8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -311,11 +311,10 @@ static int sysfs_release(struct inode * inode, struct file * filp)
 {
 	struct sysfs_buffer *buffer = filp->private_data;
 
-	if (buffer) {
-		if (buffer->page)
-			free_page((unsigned long)buffer->page);
-		kfree(buffer);
-	}
+	if (buffer->page)
+		free_page((unsigned long)buffer->page);
+	kfree(buffer);
+
 	return 0;
 }
 
-- 
1.5.0.3



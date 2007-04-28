Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbXD1Npd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbXD1Npd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbXD1Nkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:45348 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbXD1Nju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=RML+Dxo1BiJzaWEafQ9gvfsv9DLUmGZNANxjtrGOAEr5IBBd1njj7L++JRfB/ibrdvU50MV5tJwhl0eWucsPwB838p97l8wPeTMmyg2vdVjve2So/6HRCzld/4qyORMONoL0xnFlySWmIhcitnJ2AzYSMlvPDQCWXhr7tkFzQ/4=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 06/21] sysfs: make sysfs_put() ignore NULL sd
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:40 +0900
Message-Id: <11777675802688-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sysfs_put() ignore NULL sd instead of oopsing.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/sysfs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 1d61027..a3ca6d6 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -110,7 +110,7 @@ static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
 
 static inline void sysfs_put(struct sysfs_dirent * sd)
 {
-	if (atomic_dec_and_test(&sd->s_count))
+	if (sd && atomic_dec_and_test(&sd->s_count))
 		release_sysfs_dirent(sd);
 }
 
-- 
1.5.0.3



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593Ab0AKUxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0AKUxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555Ab0AKUxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:53:44 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:51440 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0AKUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=EtZG3F/IH2lNLasbfu9Ye+n0mZNlTITf1VKqzwBi9dk3unAAz9hDAslIxb3nivXQHM
         mJNY3U5ss4GY+AEoZ9LygwUtuSaRsN+QpitpVnqyBZCB2+2ZxlOY3szuGIF1OQwT00kQ
         pYTxURoxwA9bWBIhvXajhJFKNQVnaE6bkWv24=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH 13/15] pmem: Convert the semaphore mess.
Date: Mon, 11 Jan 2010 21:51:52 +0100
Message-Id: <1263243114-3942-14-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-13-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
 <1263243114-3942-2-git-send-email-jkacur@redhat.com>
 <1263243114-3942-3-git-send-email-jkacur@redhat.com>
 <1263243114-3942-4-git-send-email-jkacur@redhat.com>
 <1263243114-3942-5-git-send-email-jkacur@redhat.com>
 <1263243114-3942-6-git-send-email-jkacur@redhat.com>
 <1263243114-3942-7-git-send-email-jkacur@redhat.com>
 <1263243114-3942-8-git-send-email-jkacur@redhat.com>
 <1263243114-3942-9-git-send-email-jkacur@redhat.com>
 <1263243114-3942-10-git-send-email-jkacur@redhat.com>
 <1263243114-3942-11-git-send-email-jkacur@redhat.com>
 <1263243114-3942-12-git-send-email-jkacur@redhat.com>
 <1263243114-3942-13-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/staging/dream/pmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
index def6468..0740dfb 100644
--- a/drivers/staging/dream/pmem.c
+++ b/drivers/staging/dream/pmem.c
@@ -1232,7 +1232,7 @@ int pmem_setup(struct android_pmem_platform_data *pdata,
 	pmem[id].ioctl = ioctl;
 	pmem[id].release = release;
 	init_rwsem(&pmem[id].bitmap_sem);
-	init_MUTEX(&pmem[id].data_list_sem);
+	semaphore_init(&pmem[id].data_list_sem);
 	INIT_LIST_HEAD(&pmem[id].data_list);
 	pmem[id].dev.name = pdata->name;
 	pmem[id].dev.minor = id;
-- 
1.6.5.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497Ab0AKUwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0AKUwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346Ab0AKUwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:11 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64054 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab0AKUwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=og91pm4FF8hYhYn14dnf437FLvHgPdimEwl+cz53bSCPJfMvXRW3cfzL82R0ZdyN1d
         gzTEAjhG3/e3JGAgTyN1u8iVaEiLqgHL9tnUxEOsk74asa9a0ZTtmhjKsoLdAOw4/YKz
         mVJzbtCzvvedQk+/ZQxzalRB2Z/+KNMctdz2o=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 07/15] wwrap: Convert the semaphore mess
Date: Mon, 11 Jan 2010 21:51:46 +0100
Message-Id: <1263243114-3942-8-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-7-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
 <1263243114-3942-2-git-send-email-jkacur@redhat.com>
 <1263243114-3942-3-git-send-email-jkacur@redhat.com>
 <1263243114-3942-4-git-send-email-jkacur@redhat.com>
 <1263243114-3942-5-git-send-email-jkacur@redhat.com>
 <1263243114-3942-6-git-send-email-jkacur@redhat.com>
 <1263243114-3942-7-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

>From 041e3130496f31d0cb4887fc6183117e662f5141 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 26 Jul 2009 00:59:33 +0200
Subject: [PATCH 124/570] staging: Bulk convert the semaphore mess

init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away. Bulk convert
staging users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

I broke the original patch down into separate patches per file
because the original patch no longer applies.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/staging/otus/wwrap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
index 53d2a45..ab54e31 100644
--- a/drivers/staging/otus/wwrap.c
+++ b/drivers/staging/otus/wwrap.c
@@ -1058,7 +1058,7 @@ u8_t zfLnxCreateThread(zdev_t *dev)
 
     /* Create Mutex and keventd */
     INIT_WORK(&macp->kevent, kevent);
-    init_MUTEX(&macp->ioctl_sem);
+    semaphore_init(&macp->ioctl_sem);
 
     return 0;
 }
-- 
1.6.5.2


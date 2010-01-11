Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559Ab0AKUw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0AKUw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530Ab0AKUwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:23 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:51440 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab0AKUwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kBlJWA/Kyi+bkKMbMAlsKWkIgQoJ2MoOmzRhuaNvhmwpoGWttIcL87sQUebGCRjTFa
         I6cq2nVpRpKSKjkQfiunLsJ/zkPZlPs6gZ40LQh3fGqEXISYApYdN6sCovK3aSv3+u+t
         PzL32S6eu1zpzhKhwiOAGpdaUlVv60a80aOVw=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH 11/15] mt9t013: Convert the semaphore mess
Date: Mon, 11 Jan 2010 21:51:50 +0100
Message-Id: <1263243114-3942-12-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-11-git-send-email-jkacur@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/staging/dream/camera/mt9t013.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/camera/mt9t013.c b/drivers/staging/dream/camera/mt9t013.c
index 88229f2..1993a5d 100644
--- a/drivers/staging/dream/camera/mt9t013.c
+++ b/drivers/staging/dream/camera/mt9t013.c
@@ -122,7 +122,7 @@ struct mt9t013_ctrl {
 
 static struct mt9t013_ctrl *mt9t013_ctrl;
 static DECLARE_WAIT_QUEUE_HEAD(mt9t013_wait_queue);
-DECLARE_MUTEX(mt9t013_sem);
+DEFINE_SEMAPHORE(mt9t013_sem);
 
 extern struct mt9t013_reg mt9t013_regs; /* from mt9t013_reg.c */
 
-- 
1.6.5.2


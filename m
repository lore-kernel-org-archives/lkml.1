Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505Ab0AKUxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0AKUxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507Ab0AKUwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:13 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64054 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab0AKUwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=O/oROmTPbHf3o+/gU/xOu0sJitpT0O1WEAPejpGRXQ0fuPSu4sSmJiKyjCwFnFd8MN
         Dby62OnI/rUVvEel4023w3gQTUG7CyF0wgvUIiQRVGOFHv4cm5p4tTOofr+51mcmO1wg
         GTSjYPqVJxtOuAS1xKMTCx5FpPzAPdQMw0X1U=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 08/15] p9auth: Convert the semaphore mess
Date: Mon, 11 Jan 2010 21:51:47 +0100
Message-Id: <1263243114-3942-9-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-8-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
 <1263243114-3942-2-git-send-email-jkacur@redhat.com>
 <1263243114-3942-3-git-send-email-jkacur@redhat.com>
 <1263243114-3942-4-git-send-email-jkacur@redhat.com>
 <1263243114-3942-5-git-send-email-jkacur@redhat.com>
 <1263243114-3942-6-git-send-email-jkacur@redhat.com>
 <1263243114-3942-7-git-send-email-jkacur@redhat.com>
 <1263243114-3942-8-git-send-email-jkacur@redhat.com>
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
 drivers/staging/p9auth/p9auth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/p9auth/p9auth.c b/drivers/staging/p9auth/p9auth.c
index db79626..2946651 100644
--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -391,7 +391,7 @@ static int __init cap_init_module(void)
 	/* Initialize each device. */
 	for (i = 0; i < cap_nr_devs; i++) {
 		cap_devices[i].node_size = cap_node_size;
-		init_MUTEX(&cap_devices[i].sem);
+		semaphore_init(&cap_devices[i].sem);
 		cap_setup_cdev(&cap_devices[i], i);
 	}
 
-- 
1.6.5.2


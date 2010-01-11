Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584Ab0AKUys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0AKUys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398Ab0AKUwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:08 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33567 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab0AKUwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=brKZul9dNXuocxz/MgKnZR99tYoyQZvrZ3nBK/JjJrsO5Ik9WRegXLii/+ltYsH1WE
         qNGi4N9GDuRyrZ4hefL/BuvE3P+PF+lK9jRAeDeke3f9RS3f3Zc7tkjHlty7HZSHnI0B
         BN8KMBku3X239jNknYM5PbmVcGviOi6KkH3Tg=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 04/15] alphatrack: Convert the semaphore mess
Date: Mon, 11 Jan 2010 21:51:43 +0100
Message-Id: <1263243114-3942-5-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-4-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
 <1263243114-3942-2-git-send-email-jkacur@redhat.com>
 <1263243114-3942-3-git-send-email-jkacur@redhat.com>
 <1263243114-3942-4-git-send-email-jkacur@redhat.com>
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

I have broken the original patch down into separate patches per file
because the original patch no longer applies.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/staging/frontier/alphatrack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index 15aed87..d4d801e 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -678,7 +678,7 @@ static int usb_alphatrack_probe(struct usb_interface *intf,
 		dev_err(&intf->dev, "Out of memory\n");
 		goto exit;
 	}
-	init_MUTEX(&dev->sem);
+	semaphore_init(&dev->sem);
 	dev->intf = intf;
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
-- 
1.6.5.2


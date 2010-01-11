Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499Ab0AKUzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab0AKUzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410Ab0AKUwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:07 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:51440 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab0AKUwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=MrUOFCNbozju+x/I92iaV3Jd0Aj/MwMGAxlbk/6EThvarKUCavb2MTrE6CaHIJB7H5
         Lbhz0ytH50ioRamZCICZV+rNBRk5oW5TSm0Fj78FEnEvl45WMJbqukk1Ji0BlfUFU9o6
         VbxRDX6Ae881sF2oum3yGbmC90fO4PZG1T4IU=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 05/15] tranzport: Convert he semaphore mess
Date: Mon, 11 Jan 2010 21:51:44 +0100
Message-Id: <1263243114-3942-6-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-5-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
 <1263243114-3942-2-git-send-email-jkacur@redhat.com>
 <1263243114-3942-3-git-send-email-jkacur@redhat.com>
 <1263243114-3942-4-git-send-email-jkacur@redhat.com>
 <1263243114-3942-5-git-send-email-jkacur@redhat.com>
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
 drivers/staging/frontier/tranzport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index ef8fcc8..8aaea2a 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -153,7 +153,7 @@ struct usb_tranzport {
 };
 
 /* prevent races between open() and disconnect() */
-static DEFINE_MUTEX(disconnect_mutex);
+static DEFINE_SEMAPHORE(disconnect_mutex);
 
 static struct usb_driver usb_tranzport_driver;
 
@@ -800,7 +800,7 @@ static int usb_tranzport_probe(struct usb_interface *intf,
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


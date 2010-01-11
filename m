Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527Ab0AKUyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab0AKUyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321Ab0AKUwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:09 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64054 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab0AKUwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Q3maoum6ELYS9Yo5Ke/xxNbkLK4024NBMGQzpXPYN7mc/aooHQFeNp17kkpXREnBkr
         d2jqjInYsSiA44AW5lEZNWYFxAJXqXoAs4AwX0XvyPk6VWzjB38GKh1WD4eC1pdvJur1
         xmJtcw0o1rLJ/6MuZAyxqotVueRJRwEZQD5J4=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 02/15] usbdux.c: Convert the semaphore mess
Date: Mon, 11 Jan 2010 21:51:41 +0100
Message-Id: <1263243114-3942-3-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-2-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
 <1263243114-3942-2-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 26 Jul 2009 00:59:33 +0200
Subject: [PATCH 124/570] staging: Bulk convert the semaphore mess

init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away. Bulk convert
staging users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

I have broken the original patch down into separate patches per file because theoriginal patch no longer applies.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/staging/comedi/drivers/usbdux.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 9a1b559..33628b9 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -316,7 +316,7 @@ struct usbduxsub {
  */
 static struct usbduxsub usbduxsub[NUMUSBDUX];
 
-static DECLARE_MUTEX(start_stop_sem);
+static DEFINE_SEMAPHORE(start_stop_sem);
 
 /*
  * Stops the data acquision
@@ -2370,7 +2370,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	dev_dbg(dev, "comedi_: usbdux: "
 		"usbduxsub[%d] is ready to connect to comedi.\n", index);
 
-	init_MUTEX(&(usbduxsub[index].sem));
+	semaphore_init(&(usbduxsub[index].sem));
 	/* save a pointer to the usb device */
 	usbduxsub[index].usbdev = udev;
 
-- 
1.6.5.2


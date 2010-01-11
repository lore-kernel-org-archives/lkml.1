Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627Ab0AKUzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0AKUzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946Ab0AKUz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:55:28 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:51440 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab0AKUwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=upORon0RGOlw5xnJFM1oXXBM4PjvwtrINQkbgHS+SozZWrwqTy5GHrI1yutEydxkFJ
         g1lB9egm4YPClMi+ZKGQM86C7rVL+KO8NgcTMwfJ2yQvGeGH3p0QoKrBRn9OOJ/DvzTQ
         DgzezTY76tPL4cms2A3gEGR+LahkTff0gbt7k=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 03/15] usbduxfast: Convert the semaphore mess
Date: Mon, 11 Jan 2010 21:51:42 +0100
Message-Id: <1263243114-3942-4-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-3-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
 <1263243114-3942-2-git-send-email-jkacur@redhat.com>
 <1263243114-3942-3-git-send-email-jkacur@redhat.com>
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
 drivers/staging/comedi/drivers/usbduxfast.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 2e675cc..d3671e0 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -200,7 +200,7 @@ struct usbduxfastsub_s {
  */
 static struct usbduxfastsub_s usbduxfastsub[NUMUSBDUXFAST];
 
-static DECLARE_MUTEX(start_stop_sem);
+static DEFINE_SEMAPHORE(start_stop_sem);
 
 /*
  * bulk transfers to usbduxfast
@@ -1500,7 +1500,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	       "connect to comedi.\n", index);
 #endif
 
-	init_MUTEX(&(usbduxfastsub[index].sem));
+	semaphore_init(&(usbduxfastsub[index].sem));
 	/* save a pointer to the usb device */
 	usbduxfastsub[index].usbdev = udev;
 
-- 
1.6.5.2


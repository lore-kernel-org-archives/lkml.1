Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486Ab0AKUwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0AKUwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346Ab0AKUwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:04 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33567 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab0AKUwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=SNbcH9yfCSvd3j+x0kWyZ0rBvhadbmLgX8l6l8yAJH9NNDArL5Kzzl18zPJsvRXptf
         69OxO8rgzmL9h5IvDbl6NyYKuqk38GLwSysDYV6TUBQDS6FCBsF9SQfvia9Kme19Asma
         24ADix2nNmDmcZ4Wojy1jdFz0SxqP9y4Dm/nk=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 01/15] dt9812: Convert the semaphore mess
Date: Mon, 11 Jan 2010 21:51:40 +0100
Message-Id: <1263243114-3942-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
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

I have broken the original patch down into separate patches per file, because
the original patch no longer applies.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/staging/comedi/drivers/dt9812.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 312f4f2..91a0c5d 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -262,7 +262,7 @@ struct dt9812_usb_cmd {
 
 #define DT9812_NUM_SLOTS	16
 
-static DECLARE_MUTEX(dt9812_mutex);
+static DEFINE_SEMAPHORE(dt9812_mutex);
 
 static struct usb_device_id dt9812_table[] = {
 	{USB_DEVICE(0x0867, 0x9812)},
@@ -1124,7 +1124,7 @@ static int __init usb_dt9812_init(void)
 
 	/* Initialize all driver slots */
 	for (i = 0; i < DT9812_NUM_SLOTS; i++) {
-		init_MUTEX(&dt9812[i].mutex);
+		semaphore_init(&dt9812[i].mutex);
 		dt9812[i].serial = 0;
 		dt9812[i].usb = NULL;
 		dt9812[i].comedi = NULL;
-- 
1.6.5.2


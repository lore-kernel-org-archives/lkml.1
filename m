Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583Ab0AKUyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab0AKUyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388Ab0AKUyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:54:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:61044 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab0AKUwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=q99FnH/VsAXdjtfweykDhorEAYiVZoZGy13iiYuEnmNPRoBf+rU5MDYPAFd4q1aQVM
         EpvQ9/drgxrDMwEYyL7nSxUs9P7Ns251k9jg1X6IeP/JOFdnk8BJRbjfBTFvEQX3ygd/
         /+nPI4F5FrwrblqmrT/SdcyIxA+pIPdORpTNo=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 06/15] mimio: Convert semaphore mess
Date: Mon, 11 Jan 2010 21:51:45 +0100
Message-Id: <1263243114-3942-7-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-6-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
 <1263243114-3942-2-git-send-email-jkacur@redhat.com>
 <1263243114-3942-3-git-send-email-jkacur@redhat.com>
 <1263243114-3942-4-git-send-email-jkacur@redhat.com>
 <1263243114-3942-5-git-send-email-jkacur@redhat.com>
 <1263243114-3942-6-git-send-email-jkacur@redhat.com>
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
 drivers/staging/mimio/mimio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/mimio/mimio.c b/drivers/staging/mimio/mimio.c
index 1ba8103..63bf2db 100644
--- a/drivers/staging/mimio/mimio.c
+++ b/drivers/staging/mimio/mimio.c
@@ -160,7 +160,7 @@ static struct usb_driver mimio_driver = {
 	.id_table = mimio_table,
 };
 
-static DECLARE_MUTEX(disconnect_sem);
+static DEFINE_SEMAPHORE(disconnect_sem);
 
 static void mimio_close(struct input_dev *idev)
 {
-- 
1.6.5.2


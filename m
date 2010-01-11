Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578Ab0AKUwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab0AKUwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536Ab0AKUwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:24 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64054 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab0AKUwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=VO2kGY8KV6LVC1IgBZdbTCjv7TjB14jKjpXnTekV4GBujbi32KCyJ9ZIZ3zRKXrYdN
         vgGAVhbzTryH57YVT1Z9vuaWhli00S3iRF/lcHIspqMoc3MUcB2Rb01R5pdGs2VZV4Tq
         APxRC+5EUKMAReT3rgBhuIfmHc5nixbn3tn8w=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 14/15] rtmp_init: Convert the semaphore mess.
Date: Mon, 11 Jan 2010 21:51:53 +0100
Message-Id: <1263243114-3942-15-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-14-git-send-email-jkacur@redhat.com>
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
 <1263243114-3942-14-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/staging/rt2860/common/rtmp_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt2860/common/rtmp_init.c
index 21a95ff..9365618 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -3520,7 +3520,7 @@ int RtmpRaDevCtrlInit(struct rt_rtmp_adapter *pAd, IN RTMP_INF_TYPE infType)
 		 ("STA Driver version-%s\n", STA_DRIVER_VERSION));
 
 #ifdef RTMP_MAC_USB
-	init_MUTEX(&(pAd->UsbVendorReq_semaphore));
+	semaphore_init(&(pAd->UsbVendorReq_semaphore));
 	os_alloc_mem(pAd, (u8 **) & pAd->UsbVendorReqBuf,
 		     MAX_PARAM_BUFFER_SIZE - 1);
 	if (pAd->UsbVendorReqBuf == NULL) {
-- 
1.6.5.2


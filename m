Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930Ab0ARRSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab0ARRSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915Ab0ARRSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:18:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:29622 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0ARRSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:18:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=r21DY0FNvm01uQ0MLdz8HJ9j3HeKBiWVK9WG8l5a2KMRCDBFJbV5v0eQkRnNvosdbp
         iOCguGmp94mdzNTtV7rQ5DBHfwtXYjW9WDH8KqKqNz9gQQNTnuE4A/vXyvI5v8qqFOTU
         sjWmK1SjAWcYf8rzQeDvhDs/n0xnf/xKGmQ6o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:17:20 +0100
Message-Id: <20100118171720.14623.86072.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 24/64] ide: fix for ide_timing quantisation errors
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix for ide_timing quantisation errors

Based on commit 4f701d1 for libata.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-timings.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: b/drivers/ide/ide-timings.c
===================================================================
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -206,6 +206,12 @@ int ide_timing_compute(ide_drive_t *driv
 		t->recover = t->cycle - t->active;
 	}
 
+	/* In a few cases quantisation may produce enough errors to
+	   leave t->cycle too low for the sum of active and recovery
+	   if so we must correct this */
+	if (t->active + t->recover > t->cycle)
+		t->cycle = t->active + t->recover;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_timing_compute);

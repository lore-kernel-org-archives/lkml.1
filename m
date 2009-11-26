Return-Path: <linux-kernel-owner+w=401wt.eu-S1760769AbZKZQMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769AbZKZQMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760677AbZKZQML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:12:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52888 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758984AbZKZQMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:12:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=rhqBkq9cPlsUUqsI4pN/g+tWync4qfaTs0RjHfkbGyzMkRoCK/XcfUefxZHirwb4DF
         dSNWBm8KqAga88P9JHkXCOhvV+6riYs2m5d0F7wDegcieqiIeyXhbA+gdZw4ScLMUx7v
         ddSrffvM75nMFPtfcbOGmxpFx9dQC8155wLuM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] libata: add comment documenting PIO latency issues on UP
Date: Thu, 26 Nov 2009 17:11:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Message-Id: <200911261711.16954.bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Based on:
http://lkml.indiana.edu/hypermail/linux/kernel/0908.2/01420.html

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/libata-core.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ata/libata-core.c
===================================================================
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6624,6 +6624,13 @@ static int __init ata_init(void)
 {
 	ata_parse_force_param();
 
+	/*
+	 * FIXME: In UP case, there is only one workqueue thread and if you
+	 * have more than one PIO device, latency is bloody awful, with
+	 * occasional multi-second "hiccups" as one PIO device waits for
+	 * another.  It's an ugly wart that users DO occasionally complain
+	 * about; luckily most users have at most one PIO polled device.
+	 */
 	ata_wq = create_workqueue("ata");
 	if (!ata_wq)
 		goto free_force_tbl;

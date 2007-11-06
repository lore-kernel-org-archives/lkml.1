Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbXKFW55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbXKFW55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 17:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbXKFW5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:57:49 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:51593 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbXKFW5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:57:48 -0500
Message-ID: <4730F168.4010203@tiscali.nl>
Date: Tue, 06 Nov 2007 23:57:44 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix writing to unintended memory in eth16i_probe_port();
 drivers/net/eth16i.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

14 is added as an offset to the array dummy_packet (64 unsigned chars) to
serve as a destination address in a call to memset(). However, when added, 
it is automatically scaled by the size of dummy_packet, which is 64. This
results in writing to unintended memory.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/eth16i.c b/drivers/net/eth16i.c
index e3dd8b1..1ae0b3e 100644
--- a/drivers/net/eth16i.c
+++ b/drivers/net/eth16i.c
@@ -680,7 +680,7 @@ static int eth16i_probe_port(int ioaddr)
 
 	dummy_packet[12] = 0x00;
 	dummy_packet[13] = 0x04;
-	memset(dummy_packet + 14, 0, sizeof(dummy_packet) - 14);
+	memset((char *)dummy_packet + 14, 0, sizeof(dummy_packet) - 14);
 
 	eth16i_select_regbank(2, ioaddr);
 


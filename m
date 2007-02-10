Return-Path: <linux-kernel-owner+w=401wt.eu-S1751796AbXBJTD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbXBJTD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 14:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXBJTD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 14:03:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61102 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbXBJTD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 14:03:56 -0500
From: Gerhard Dirschl <gd@spherenet.de>
To: Peter Osterlund <petero2@telia.com>
Subject: [PATCH] pktcdvd: Correctly set cmd_len field in pkt_generic_packet
Date: Sat, 10 Feb 2007 20:03:46 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702102003.46376.gd@spherenet.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9a410c39813cf3098e4757d92f0a362c
X-Provags-ID2: V01U2FsdGVkX1+kfMTyH+4nUuE+1pk66+s6Wex92E7Riqz86Kaqwhj3zZhoWMLTeVLvLOdgUWtxmXhckxfsDx+MjYb7ogMCVO03gVNAHK9gHxj0j0NQtpj7IQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=7810 - a silly
copy-paste bug introduced by the latest change.

Signed-off-by: Gerhard Dirschl <gd@spherenet.de>
---
Maybe it fixes http://bugzilla.kernel.org/show_bug.cgi?id=7910
as well.

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 6246219..dd38c30 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -777,7 +777,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 			goto out;
 	}
 
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
+	rq->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
 	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
 	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
 		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);

-- 
Gerhard Dirschl        PGP-Key-ID: 0x7B95AE94
Germany

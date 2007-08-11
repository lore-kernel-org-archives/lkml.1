Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbXHKIZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbXHKIZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 04:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXHKIZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 04:25:18 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4649 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbXHKIZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 04:25:16 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH -mm] drivers/scsi/megaraid.c: bugfix
Date: Sat, 11 Aug 2007 10:25:12 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Joe Perches <joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708111025.12885.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This is one of the 'possible downsides: embarrassment' situation described
by Randy in his papers on linux development. I introduced a bug while doin conversion
to kzalloc and this is a fix. We can not return here as we are under lock. Live and learn.

Please apply.

Regards,

	Mariusz

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/megaraid.c | 116094 -> 116063 (-31 bytes)
 drivers/scsi/megaraid.o | 257984 -> 257868 (-116 bytes)

 drivers/scsi/megaraid.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.23-rc2-mm2-a/drivers/scsi/megaraid.c	2007-08-10 12:46:10.000000000 +0200
+++ linux-2.6.23-rc2-mm2-b/drivers/scsi/megaraid.c	2007-08-11 10:03:25.000000000 +0200
@@ -4409,9 +4409,6 @@ mega_internal_command(adapter_t *adapter
 	memset(scmd, 0, sizeof(Scsi_Cmnd));

 	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
-	if (!sdev)
-		return -ENOMEM;
-
 	scmd->device = sdev;

 	scmd->device->host = adapter->host;

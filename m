Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYHRQ6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYHRQ6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYHRQ63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:58:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:5670 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbYHRQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Pv827ic7o/L8zZh9QgRUKb04ZfuHtnJvUkMGdysyRSLzrwjrSM3YPLueZsmT9rcua1
         9DAYt5FR277N10S+zybvgQOaBsnGsxzNk5OUMKaMQkqcIhtbQ+h+I8v82FqVhyMsGCvm
         gdkZ4WXNw9Sv/PbsSdm605jsz5LQw2FuhF47s=
Message-ID: <48A9FE94.6080905@gmail.com>
Date: Mon, 18 Aug 2008 18:58:28 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: paul@paulbristow.net, linux-kernel@vger.kernel.org
Subject: [PATCH] floppy: duplicate FD_RAW_NEED_DISK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe some other flag was needed? otherwise the
patch below cleans it up.
---
duplicate FD_RAW_NEED_DISK

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 395f8ea..c59ae10 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2622,8 +2622,7 @@ static int make_raw_rw_request(void)
 	set_fdc((long)current_req->rq_disk->private_data);
 
 	raw_cmd = &default_raw_cmd;
-	raw_cmd->flags = FD_RAW_SPIN | FD_RAW_NEED_DISK | FD_RAW_NEED_DISK |
-	    FD_RAW_NEED_SEEK;
+	raw_cmd->flags = FD_RAW_SPIN | FD_RAW_NEED_DISK | FD_RAW_NEED_SEEK;
 	raw_cmd->cmd_count = NR_RW;
 	if (rq_data_dir(current_req) == READ) {
 		raw_cmd->flags |= FD_RAW_READ;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYFUTXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYFUTXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYFUTWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:22:33 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:56041 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbYFUTW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Nkq+JptTEtfVZex1KttbABC7TjUZcm7gRNXT2e3x7eJLCyhcDZx3ClslfrwhQDAxKN
         2PvKHSq37OqUcBcEYYbE8nyb9Vx+KvUIZTZEhW9GkQMCWjxnWjxFcKqSlDbjE/gDHPWx
         UKilFBq8SibnlyqE6ephAVknsVi+RbTfstd1U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/4] ide: filter out invalid transfer mode values in set_xfer_rate()
Date: Sat, 21 Jun 2008 21:20:41 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806212120.41514.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filter out invalid transfer mode values (0x02-0x07) in write handler
for obsoleted /proc/ide/hd?/settings:current_speed setting.

While at it:

* Use XFER_UDMA_6 define.

Suggested-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Sergei, IIRC that it is what you were suggesting some time ago.

drivers/ide/ide-proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -345,7 +345,7 @@ static int set_xfer_rate (ide_drive_t *d
 	ide_task_t task;
 	int err;
 
-	if (arg < 0 || arg > 70)
+	if (arg < 0 || (arg > 1 && arg < XFER_PIO_0) || arg > XFER_UDMA_6)
 		return -EINVAL;
 
 	memset(&task, 0, sizeof(task));

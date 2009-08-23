Return-Path: <linux-kernel-owner+w=401wt.eu-S933693AbZHWS0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbZHWS0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 14:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933571AbZHWS0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 14:26:13 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62122 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448AbZHWS0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 14:26:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=byzmL/3/UvPPTXQVZfAwasmlTZWi/En1tFEHJsxfrfxOyUuiR/e3N4lHIIScvgvVU0
         +rFNg2H/2qskPRiRUOThyExHIewRKaSIgCnJ6bH/RTpFPc4qBGGPK8n08kYUvJAlFqxk
         yvB9o5aFX3XgXHsB6XpZFUuGRwkKVI7j5EQ0g=
Message-ID: <4A9189C3.2020706@gmail.com>
Date: Sun, 23 Aug 2009 20:26:11 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH resend] ide: use printk_once
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: ide: use printk_once

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 3242698..6e58e7e 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -236,14 +236,8 @@ static const struct ide_proc_devset ide_generic_settings[] = {
 
 static void proc_ide_settings_warn(void)
 {
-	static int warned;
-
-	if (warned)
-		return;
-
-	printk(KERN_WARNING "Warning: /proc/ide/hd?/settings interface is "
+	printk_once(KERN_WARNING "Warning: /proc/ide/hd?/settings interface is "
 			    "obsolete, and will be removed soon!\n");
-	warned = 1;
 }
 
 static int proc_ide_read_settings

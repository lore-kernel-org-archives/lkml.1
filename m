Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZHITy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZHITy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZHITyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:54:54 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:46204 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZHITyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eKrifsEe8VuiB5/KF5rMVpxG73a3OQigPcn3zX3hvBIbKZDej5JgzZLz/XJnF10Ffd
         u4hmC/PsDgAkpvbNZpz4yNpnx1j9foBJT6IwVmUgCpHz0MSsClDVM3mtJOZthGuk71yz
         39Gm/Rd4z/A+fJIXJL27u5Jxqte42a8At3Txs=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 09/14] ide: use printk_once
Date: Sun,  9 Aug 2009 21:54:04 +0200
Message-Id: <1249847649-11631-10-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-proc.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

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
-- 
1.6.3.3


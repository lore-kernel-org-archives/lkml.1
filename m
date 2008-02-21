Return-Path: <linux-kernel-owner+w=401wt.eu-S936176AbYBUXvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936176AbYBUXvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933443AbYBUXsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:48:37 -0500
Received: from ns1.suse.de ([195.135.220.2]:45030 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935445AbYBUXse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:48:34 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/11] ide: mark "ide=reverse" option as obsolete
Date: Thu, 21 Feb 2008 15:48:02 -0800
Message-Id: <1203637687-7273-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080221234649.GB7128@kroah.com>
References: <20080221234649.GB7128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

- it is valid only if "Probe IDE PCI devices in the PCI bus order
  (DEPRECATED)" config option is used

- Greg needs to remove pci_get_device_reverse() for PCI core changes

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/ide.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 4a8952a..477833f 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1229,7 +1229,7 @@ static int __init ide_setup(char *s)
 	if (!strcmp(s, "ide=reverse")) {
 		ide_scan_direction = 1;
 		printk(" : Enabled support for IDE inverse scan order.\n");
-		return 1;
+		goto obsolete_option;
 	}
 #endif
 
-- 
1.5.4


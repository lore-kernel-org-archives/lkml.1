Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYGVFX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYGVFX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYGVFWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:02 -0400
Received: from mail.suse.de ([195.135.220.2]:53694 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbYGVFWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jan Harkes <jaharkes@cs.cmu.edu>
Subject: [PATCH 07/79] device create: coda: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:31 -0700
Message-Id: <1216703983-21448-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/coda/psdev.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index e3eb355..40c36f7 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -362,8 +362,9 @@ static int init_coda_psdev(void)
 		goto out_chrdev;
 	}		
 	for (i = 0; i < MAX_CODADEVS; i++)
-		device_create(coda_psdev_class, NULL,
-			      MKDEV(CODA_PSDEV_MAJOR,i), "cfs%d", i);
+		device_create_drvdata(coda_psdev_class, NULL,
+				      MKDEV(CODA_PSDEV_MAJOR, i),
+				      NULL, "cfs%d", i);
 	coda_sysctl_init();
 	goto out;
 
-- 
1.5.6.3


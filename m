Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbYAYHTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbYAYHTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbYAYHO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:14:58 -0500
Received: from ns2.suse.de ([195.135.220.15]:47460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137AbYAYHO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:14:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tony Jones <tonyj@suse.de>, Jens Axboe <axboe@kernel.dk>,
       Sam Hopkins <sah@coraid.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 017/196] aoechr: Convert from class_device to device
Date: Thu, 24 Jan 2008 23:09:15 -0800
Message-Id: <1201245134-4876-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sam Hopkins <sah@coraid.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/aoe/aoechr.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 39e563e..d5480e3 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -259,9 +259,8 @@ aoechr_init(void)
 		return PTR_ERR(aoe_class);
 	}
 	for (i = 0; i < ARRAY_SIZE(chardevs); ++i)
-		class_device_create(aoe_class, NULL,
-					MKDEV(AOE_MAJOR, chardevs[i].minor),
-					NULL, chardevs[i].name);
+		device_create(aoe_class, NULL,
+			      MKDEV(AOE_MAJOR, chardevs[i].minor), chardevs[i].name);
 
 	return 0;
 }
@@ -272,7 +271,7 @@ aoechr_exit(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(chardevs); ++i)
-		class_device_destroy(aoe_class, MKDEV(AOE_MAJOR, chardevs[i].minor));
+		device_destroy(aoe_class, MKDEV(AOE_MAJOR, chardevs[i].minor));
 	class_destroy(aoe_class);
 	unregister_chrdev(AOE_MAJOR, "aoechr");
 }
-- 
1.5.3.8


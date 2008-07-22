Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYGVF1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYGVF1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYGVFWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:41 -0400
Received: from mx1.suse.de ([195.135.220.2]:53768 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbYGVFWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Karsten Keil <kkeil@suse.de>
Subject: [PATCH 17/79] device create: isdn: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:41 -0700
Message-Id: <1216703983-21448-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/isdn/capi/capi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 8a35029..0dcfbfb 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1552,7 +1552,8 @@ static int __init capi_init(void)
 		return PTR_ERR(capi_class);
 	}
 
-	device_create(capi_class, NULL, MKDEV(capi_major, 0), "capi");
+	device_create_drvdata(capi_class, NULL, MKDEV(capi_major, 0), NULL,
+			      "capi");
 
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
 	if (capinc_tty_init() < 0) {
-- 
1.5.6.3


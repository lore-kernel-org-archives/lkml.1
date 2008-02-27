Return-Path: <linux-kernel-owner+w=401wt.eu-S1763677AbYB0CXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763677AbYB0CXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 21:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYB0CXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 21:23:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53918 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbYB0CXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 21:23:45 -0500
Message-ID: <47C4C954.1090006@cn.fujitsu.com>
Date: Wed, 27 Feb 2008 10:22:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] CONNECTOR: make cn_already_initialized static
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is used in connector.c only, so make it static.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/connector/connector.c |    2 +-
 include/linux/connector.h     |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index fea2d3e..85e2ba7 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -47,7 +47,7 @@ static LIST_HEAD(notify_list);
 
 static struct cn_dev cdev;
 
-int cn_already_initialized = 0;
+static int cn_already_initialized;
 
 /*
  * msg->seq and msg->ack are used to determine message genealogy.
diff --git a/include/linux/connector.h b/include/linux/connector.h
index da6dd95..96a89d3 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -170,7 +170,5 @@ int cn_cb_equal(struct cb_id *, struct cb_id *);
 
 void cn_queue_wrapper(struct work_struct *work);
 
-extern int cn_already_initialized;
-
 #endif				/* __KERNEL__ */
 #endif				/* __CONNECTOR_H */
-- 
1.5.4.rc3


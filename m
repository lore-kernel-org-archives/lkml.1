Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbYAYH4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbYAYH4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761854AbYAYHgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:43 -0500
Received: from mail.suse.de ([195.135.220.2]:55396 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762038AbYAYHgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 102/196] driver core: clean up shutdown.c
Date: Thu, 24 Jan 2008 23:32:11 -0800
Message-Id: <1201246425-5058-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shutdown.c had some stuff it did not need, including a duplicate extern
in the power.h file.  This cleans up all of that.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/power.h    |    7 -------
 drivers/base/power/shutdown.c |    5 -----
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 10c2084..6f0dfca 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -1,10 +1,3 @@
-/*
- * shutdown.c
- */
-
-extern void device_shutdown(void);
-
-
 #ifdef CONFIG_PM_SLEEP
 
 /*
diff --git a/drivers/base/power/shutdown.c b/drivers/base/power/shutdown.c
index f51cbc1..5b6bc16 100644
--- a/drivers/base/power/shutdown.c
+++ b/drivers/base/power/shutdown.c
@@ -12,10 +12,6 @@
 #include <asm/semaphore.h>
 
 #include "../base.h"
-#include "power.h"
-
-#define to_dev(node) container_of(node, struct device, kobj.entry)
-
 
 /**
  * We handle system devices differently - we suspend and shut them
@@ -45,4 +41,3 @@ void device_shutdown(void)
 		}
 	}
 }
-
-- 
1.5.3.8


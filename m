Return-Path: <linux-kernel-owner+w=401wt.eu-S934319AbZFPFyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319AbZFPFyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760268AbZFPFvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:02 -0400
Received: from kroah.org ([198.145.64.141]:48324 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761603AbZFPFvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>, Arjan van de Ven <arjan@infradead.org>,
       Dmitry Torokhov <dtor@mail.ru>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/64] driver core: synchronize device shutdown
Date: Mon, 15 Jun 2009 22:46:02 -0700
Message-Id: <1245131213-24168-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

A patch series to make .shutdown execute asynchronously.  Some drivers's
shutdown can take a lot of time.  The patches can help save some shutdown
time.  The patches use Arjan's async API.


This patch:

synchronize all tasks submitted by .shutdown

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 1977d4b..7e8576d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -22,6 +22,7 @@
 #include <linux/kallsyms.h>
 #include <linux/semaphore.h>
 #include <linux/mutex.h>
+#include <linux/async.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -1665,4 +1666,5 @@ void device_shutdown(void)
 	kobject_put(sysfs_dev_char_kobj);
 	kobject_put(sysfs_dev_block_kobj);
 	kobject_put(dev_kobj);
+	async_synchronize_full();
 }
-- 
1.6.3.2


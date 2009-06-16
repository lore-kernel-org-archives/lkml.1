Return-Path: <linux-kernel-owner+w=401wt.eu-S936123AbZFPFzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936123AbZFPFzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934501AbZFPFvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:06 -0400
Received: from kroah.org ([198.145.64.141]:48333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759069AbZFPFvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/64] driver core: fix documentation of request_firmware_nowait
Date: Mon, 15 Jun 2009 22:46:04 -0700
Message-Id: <1245131213-24168-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

request_firmware_nowait declares it can be called in non-sleep contexts,
but kthead_run called by request_firmware_nowait may sleep. So fix its
documentation and comment to make callers clear about it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/firmware_class/README |    3 ++-
 drivers/base/firmware_class.c       |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
index c3480aa..7eceaff 100644
--- a/Documentation/firmware_class/README
+++ b/Documentation/firmware_class/README
@@ -77,7 +77,8 @@
    seconds for the whole load operation.
 
  - request_firmware_nowait() is also provided for convenience in
-   non-user contexts.
+   user contexts to request firmware asynchronously, but can't be called
+   in atomic contexts.
 
 
  about in-kernel persistence:
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 2d296b7..2427702 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -617,8 +617,9 @@ request_firmware_work_func(void *arg)
  * @cont: function will be called asynchronously when the firmware
  *	request is over.
  *
- *	Asynchronous variant of request_firmware() for contexts where
- *	it is not possible to sleep.
+ *	Asynchronous variant of request_firmware() for user contexts where
+ *	it is not possible to sleep for long time. It can't be called
+ *	in atomic contexts.
  **/
 int
 request_firmware_nowait(
-- 
1.6.3.2


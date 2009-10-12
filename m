Return-Path: <linux-kernel-owner+w=401wt.eu-S933043AbZJLSSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbZJLSSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932837AbZJLSSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:18:33 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:60885 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827AbZJLSSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:18:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AD372E1.50002@cam.ac.uk>
Date: Mon, 12 Oct 2009 19:18:09 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091007)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH] staging: iio: Fix missing include <linux/sched.h>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/sched.h include was removed form linux/poll.h by
commmit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184

Required for definition of TASK_INTERRUPTIBLE amongst others
---

Ingo posted a couple of similar patches in reply to Linus'
2.6.32-rc4 thread. I guess there will be quite a few more
to come.

 drivers/staging/iio/industrialio-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 1fa18f2..8b67c17 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -18,6 +18,7 @@
 #include <linux/fs.h>
 #include <linux/interrupt.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
 #include <linux/cdev.h>
 #include "iio.h"
 #include "trigger_consumer.h"
-- 
1.6.3.3


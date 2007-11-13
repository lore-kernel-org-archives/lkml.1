Return-Path: <linux-kernel-owner+w=401wt.eu-S1763405AbXKMVe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763405AbXKMVe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760508AbXKMVeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:34:15 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:49778 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759429AbXKMVeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:34:13 -0500
Date: Tue, 13 Nov 2007 22:34:09 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dan@dennedy.org, stefanr@s5r6.in-berlin.de,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] drivers/ieee1394: Drop redundant includes of moduleparam.h
Message-ID: <Pine.LNX.4.64.0711132233220.18337@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Drop #include <linux/moduleparam.h> in files that also include #include
<linux/module.h>.  module.h includes moduleparam.h already.

The semantic patch implementing this change is as follows:

@ includesmodule @
@@

#include <linux/module.h>

@ depends on includesmodule @
@@

- #include <linux/moduleparam.h>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p -b -B a/drivers/ieee1394/csr.c b/drivers/ieee1394/csr.c
--- a/drivers/ieee1394/csr.c 2007-02-09 17:34:08.000000000 +0100
+++ b/drivers/ieee1394/csr.c 2007-11-13 17:49:47.000000000 +0100
@@ -20,7 +20,6 @@
  #include <linux/jiffies.h>
  #include <linux/kernel.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/param.h>
  #include <linux/spinlock.h>
  #include <linux/string.h>
diff -u -p -b -B a/drivers/ieee1394/ieee1394_core.c b/drivers/ieee1394/ieee1394_core.c
--- a/drivers/ieee1394/ieee1394_core.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/ieee1394/ieee1394_core.c 2007-11-13 17:49:50.000000000 +0100
@@ -27,7 +27,6 @@
  #include <linux/slab.h>
  #include <linux/interrupt.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/bitops.h>
  #include <linux/kdev_t.h>
  #include <linux/freezer.h>
diff -u -p -b -B a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
--- a/drivers/ieee1394/nodemgr.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/ieee1394/nodemgr.c 2007-11-13 17:49:51.000000000 +0100
@@ -15,7 +15,6 @@
  #include <linux/delay.h>
  #include <linux/kthread.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/mutex.h>
  #include <linux/freezer.h>
  #include <asm/atomic.h>
diff -u -p -b -B a/drivers/ieee1394/ohci1394.c b/drivers/ieee1394/ohci1394.c
--- a/drivers/ieee1394/ohci1394.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/ieee1394/ohci1394.c 2007-11-13 17:49:52.000000000 +0100
@@ -89,7 +89,6 @@
  #include <linux/wait.h>
  #include <linux/errno.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/pci.h>
  #include <linux/fs.h>
  #include <linux/poll.h>
diff -u -p -b -B a/drivers/ieee1394/pcilynx.c b/drivers/ieee1394/pcilynx.c
--- a/drivers/ieee1394/pcilynx.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/ieee1394/pcilynx.c 2007-11-13 17:49:54.000000000 +0100
@@ -36,7 +36,6 @@
  #include <linux/wait.h>
  #include <linux/errno.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/init.h>
  #include <linux/pci.h>
  #include <linux/fs.h>
diff -u -p -b -B a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
--- a/drivers/ieee1394/sbp2.c 2007-11-08 08:00:51.000000000 +0100
+++ b/drivers/ieee1394/sbp2.c 2007-11-13 17:49:56.000000000 +0100
@@ -61,7 +61,6 @@
  #include <linux/list.h>
  #include <linux/mm.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/sched.h>
  #include <linux/slab.h>
  #include <linux/spinlock.h>

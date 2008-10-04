Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYJDKLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYJDKLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 06:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYJDKLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 06:11:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34958 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYJDKLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 06:11:21 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
       Andre Noll <maan@systemlinux.org>
Subject: [mmotm 02/Oct] fix buid error of md raid
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081004190725.CE3E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081004190725.CE3E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081004190956.CE44.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sat,  4 Oct 2008 19:11:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against: mmotm 02 Oct
Applied after: git-md.patch


fix following build error

--------------------
  CC      drivers/md/raid1.o
drivers/md/raid1.c: In function 'sync_request':
drivers/md/raid1.c:1759: error: implicit declaration of function 'msleep_interruptible'
make[2]: *** [drivers/md/raid1.o] Error 1
make[1]: *** [drivers/md] Error 2
make: *** [drivers] Error 2

  CC      drivers/md/raid10.o
drivers/md/raid10.c: In function 'sync_request':
drivers/md/raid10.c:1749: error: implicit declaration of function 'msleep_interruptible'
make[2]: *** [drivers/md/raid10.o] Error 1


  CC      drivers/md/md.o
drivers/md/md.c: In function 'md_do_sync':
drivers/md/md.c:5914: error: implicit declaration of function 'msleep'
drivers/md/md.c: In function 'md_notify_reboot':
drivers/md/md.c:6265: error: implicit declaration of function 'mdelay'
make[2]: *** [drivers/md/md.o] Error 1
make[1]: *** [drivers/md] Error 2
make: *** [drivers] Error 2
----------------------


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: NeilBrown <neilb@suse.de>
CC: Andre Noll <maan@systemlinux.org>

---
 drivers/md/md.c     |    1 +
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 3 files changed, 3 insertions(+)

Index: b/drivers/md/raid1.c
===================================================================
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -34,6 +34,7 @@
 #include "dm-bio-list.h"
 #include <linux/raid/raid1.h>
 #include <linux/raid/bitmap.h>
+#include <linux/delay.h>
 
 #define DEBUG 0
 #if DEBUG
Index: b/drivers/md/md.c
===================================================================
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -44,6 +44,7 @@
 #include <linux/random.h>
 #include <linux/reboot.h>
 #include <linux/file.h>
+#include <linux/delay.h>
 
 #define MAJOR_NR MD_MAJOR
 
Index: b/drivers/md/raid10.c
===================================================================
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -21,6 +21,7 @@
 #include "dm-bio-list.h"
 #include <linux/raid/raid10.h>
 #include <linux/raid/bitmap.h>
+#include <linux/delay.h>
 
 /*
  * RAID10 provides a combination of RAID0 and RAID1 functionality.



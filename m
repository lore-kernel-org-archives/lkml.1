Return-Path: <linux-kernel-owner+w=401wt.eu-S934048AbZJMSgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048AbZJMSgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933996AbZJMSgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:36:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59673 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934038AbZJMSgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:36:46 -0400
Date: Tue, 13 Oct 2009 20:36:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [GIT PULL] header fixes
Message-ID: <20091013183601.GA16740@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the header-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git header-fixes-for-linus

This fixes the sched.h / interrupt.h related fallout from the (very 
nice) d43c36d header files dependency cleanup.

 Thanks,

	Ingo

------------------>
Ingo Molnar (7):
      headers: Fix build in drivers/pci/hotplug/cpqphp.h
      headers: Fix build in drivers/char/rtc.c
      headers: Fix build in drivers/net/wan/pci200syn.c
      headers: Fix build in drivers/net/wan/n2.c
      headers: Fix build in drivers/net/wan/c101.c
      headers: Fix build in drivers/char/genrtc.c
      headers: Fix build in drivers/char/sonypi.c


 drivers/char/genrtc.c        |    1 +
 drivers/char/rtc.c           |    1 +
 drivers/char/sonypi.c        |    1 +
 drivers/net/wan/c101.c       |    1 +
 drivers/net/wan/n2.c         |    1 +
 drivers/net/wan/pci200syn.c  |    1 +
 drivers/pci/hotplug/cpqphp.h |    1 +
 7 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index aac0985..31e7c91 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -43,6 +43,7 @@
 #define RTC_VERSION	"1.07"
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/fcntl.h>
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index e0d0f8b..bc4ab3e 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -74,6 +74,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
+#include <linux/sched.h>
 #include <linux/sysctl.h>
 #include <linux/wait.h>
 #include <linux/bcd.h>
diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index fd3dced..8c262aa 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -36,6 +36,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/input.h>
 #include <linux/pci.h>
 #include <linux/init.h>
diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index 9693b0f..0bd898c 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/capability.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff --git a/drivers/net/wan/n2.c b/drivers/net/wan/n2.c
index 83da596..58c6681 100644
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -18,6 +18,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/capability.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index a52f29c..f1340fa 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/capability.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index 5383600..9c6a9fd 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -32,6 +32,7 @@
 #include <asm/io.h>		/* for read? and write? functions */
 #include <linux/delay.h>	/* for delays */
 #include <linux/mutex.h>
+#include <linux/sched.h>	/* for signal_pending() */
 
 #define MY_NAME	"cpqphp"
 

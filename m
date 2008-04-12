Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYDLQS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYDLQS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYDLQSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:18:21 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:41933 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYDLQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=qfjUrFsh2DM/JOqoS9ASnsahjlTqmSSSL7x4jmLsMQJqKiwIIWqeiTqjdBthnqJS7cfrouAgl7WpBxDdl+k+6s+hbEfBAaY7iOdqJBECKB8jiFUz8ZpHMUUtDyYeKFAqc1tZCQpF3Y7zTQ60obOuzAVRIPjRTa/whVHR51oYtyA=
Date: Sun, 13 Apr 2008 00:14:39 +0800 (CST)
Message-Id: <20080413.001439.130519292.xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] UML: Make several things static.
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make several things static, because they no longer need to be global.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
 arch/um/drivers/net_kern.c      |    6 +++---
 arch/um/drivers/slip_kern.c     |    4 ++--
 arch/um/drivers/stdio_console.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 1d43bdf..5b4ca8d 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -116,7 +116,7 @@ static void uml_dev_close(struct work_struct *work)
 	dev_close(lp->dev);
 }
 
-irqreturn_t uml_net_interrupt(int irq, void *dev_id)
+static irqreturn_t uml_net_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct uml_net_private *lp = dev->priv;
@@ -296,7 +296,7 @@ static struct ethtool_ops uml_net_ethtool_ops = {
 	.get_link	= ethtool_op_get_link,
 };
 
-void uml_net_user_timer_expire(unsigned long _conn)
+static void uml_net_user_timer_expire(unsigned long _conn)
 {
 #ifdef undef
 	struct connection *conn = (struct connection *)_conn;
@@ -786,7 +786,7 @@ static int uml_inetaddr_event(struct notifier_block *this, unsigned long event,
 }
 
 /* uml_net_init shouldn't be called twice on two CPUs at the same time */
-struct notifier_block uml_inetaddr_notifier = {
+static struct notifier_block uml_inetaddr_notifier = {
 	.notifier_call		= uml_inetaddr_event,
 };
 
diff --git a/arch/um/drivers/slip_kern.c b/arch/um/drivers/slip_kern.c
index 6b4a0f9..d19faec 100644
--- a/arch/um/drivers/slip_kern.c
+++ b/arch/um/drivers/slip_kern.c
@@ -13,7 +13,7 @@ struct slip_init {
 	char *gate_addr;
 };
 
-void slip_init(struct net_device *dev, void *data)
+static void slip_init(struct net_device *dev, void *data)
 {
 	struct uml_net_private *private;
 	struct slip_data *spri;
@@ -57,7 +57,7 @@ static int slip_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 			       (struct slip_data *) &lp->user);
 }
 
-const struct net_kern_info slip_kern_info = {
+static const struct net_kern_info slip_kern_info = {
 	.init			= slip_init,
 	.protocol		= slip_protocol,
 	.read			= slip_read,
diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_console.c
index cec0c33..49266f6 100644
--- a/arch/um/drivers/stdio_console.c
+++ b/arch/um/drivers/stdio_console.c
@@ -34,7 +34,7 @@
 
 static struct tty_driver *console_driver;
 
-void stdio_announce(char *dev_name, int dev)
+static void stdio_announce(char *dev_name, int dev)
 {
 	printk(KERN_INFO "Virtual console %d assigned device '%s'\n", dev,
 	       dev_name);
@@ -158,7 +158,7 @@ static struct console stdiocons = {
 	.index		= -1,
 };
 
-int stdio_init(void)
+static int stdio_init(void)
 {
 	char *new_title;
 
-- 
1.5.2.4


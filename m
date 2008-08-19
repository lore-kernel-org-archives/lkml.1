Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbYHSVv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbYHSVv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYHSVug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:50:36 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:52918 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759555AbYHSVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:50:34 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rodolfo Giometti <giometti@linux.it>
Date: Tue, 19 Aug 2008 23:50:07 +0200
Message-Id: <1219182612-13814-6-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1219182612-13814-5-git-send-email-giometti@linux.it>
References: <>
 <1219182612-13814-1-git-send-email-giometti@linux.it>
 <1219182612-13814-2-git-send-email-giometti@linux.it>
 <1219182612-13814-3-git-send-email-giometti@linux.it>
 <1219182612-13814-4-git-send-email-giometti@linux.it>
 <1219182612-13814-5-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 05/10] ldisc: new dcd_change() method for line disciplines.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 Documentation/tty.txt     |    4 ++++
 include/linux/tty_ldisc.h |   10 ++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/tty.txt b/Documentation/tty.txt
index 8e65c44..3fc812a 100644
--- a/Documentation/tty.txt
+++ b/Documentation/tty.txt
@@ -100,6 +100,10 @@ write_wakeup()	-	May be called at any point between open and close.
 			is permitted to call the driver write method from
 			this function. In such a situation defer it.
 
+dcd_change()	-	Report to the tty line the current DCD pin status
+			changes and the relative timestamp. The timestamp
+			can be NULL.
+
 
 Driver Access
 
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 40f38d8..e74a28b 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -99,11 +99,19 @@
  *	cease I/O to the tty driver. Can sleep. The driver should
  *	seek to perform this action quickly but should wait until
  *	any pending driver I/O is completed.
+ *
+ * void (*dcd_change)(struct uart_port *port, unsigned int status,
+ * 			struct timespec *ts)
+ *
+ *	Tells the discipline that the DCD pin has changed its status and
+ *	the relative timestamp. Pointer ts can be NULL.
  */
 
 #include <linux/fs.h>
 #include <linux/wait.h>
 
+struct uart_port;
+
 struct tty_ldisc_ops {
 	int	magic;
 	char	*name;
@@ -136,6 +144,8 @@ struct tty_ldisc_ops {
 	void	(*receive_buf)(struct tty_struct *, const unsigned char *cp,
 			       char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
+	void	(*dcd_change)(struct uart_port *, unsigned int,
+				struct timespec *);
 
 	struct  module *owner;
 	
-- 
1.5.4.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYKYVLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYKYVLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYKYVLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:11:19 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:52575 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYKYVLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:11:18 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Rodolfo Giometti <giometti@linux.it>
Date: Tue, 25 Nov 2008 22:11:07 +0100
Message-Id: <1227647470-4816-2-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227647470-4816-1-git-send-email-giometti@linux.it>
References: <>
 <1227647470-4816-1-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] ldisc: new dcd_change() method for line disciplines.
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
index 6226504..a135d6c 100644
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
 struct tty_ldisc {
 	int	magic;
 	char	*name;
@@ -136,6 +144,8 @@ struct tty_ldisc {
 	void	(*receive_buf)(struct tty_struct *, const unsigned char *cp,
 			       char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
+	void	(*dcd_change)(struct uart_port *, unsigned int,
+				struct timespec *);
 
 	struct  module *owner;
 	
-- 
1.5.4.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0BWMlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 07:41:06 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:37749 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab0BWMk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 07:40:58 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>,
       Rodolfo Giometti <giometti@linux.it>
Date: Tue, 23 Feb 2010 13:40:31 +0100
Message-Id: <1266928835-5435-3-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266928835-5435-2-git-send-email-giometti@linux.it>
References: <1266928835-5435-1-git-send-email-giometti@linux.it>
 <1266928835-5435-2-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 2/6] ldisc: new dcd_change() method for line disciplines.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 Documentation/serial/tty.txt |    4 ++++
 include/linux/tty_ldisc.h    |    8 ++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/serial/tty.txt b/Documentation/serial/tty.txt
index 5e5349a..7c90050 100644
--- a/Documentation/serial/tty.txt
+++ b/Documentation/serial/tty.txt
@@ -105,6 +105,10 @@ write_wakeup()	-	May be called at any point between open and close.
 			is permitted to call the driver write method from
 			this function. In such a situation defer it.
 
+dcd_change()	-	Report to the tty line the current DCD pin status
+			changes and the relative timestamp. The timestamp
+			can be NULL.
+
 
 Driver Access
 
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 0c4ee9b..526d66f 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -99,6 +99,12 @@
  *	cease I/O to the tty driver. Can sleep. The driver should
  *	seek to perform this action quickly but should wait until
  *	any pending driver I/O is completed.
+ *
+ * void (*dcd_change)(struct tty_struct *tty, unsigned int status,
+ * 			struct timespec *ts)
+ *
+ *	Tells the discipline that the DCD pin has changed its status and
+ *	the relative timestamp. Pointer ts can be NULL.
  */
 
 #include <linux/fs.h>
@@ -136,6 +142,8 @@ struct tty_ldisc_ops {
 	void	(*receive_buf)(struct tty_struct *, const unsigned char *cp,
 			       char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
+	void	(*dcd_change)(struct tty_struct *, unsigned int,
+				struct timespec *);
 
 	struct  module *owner;
 	
-- 
1.6.3.3


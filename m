Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0BPJwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:52:45 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39851 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab0BPJv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:51:59 -0500
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
Date: Tue, 16 Feb 2010 10:51:22 +0100
Message-Id: <1266313885-1195-6-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266313885-1195-5-git-send-email-giometti@linux.it>
References: <1266313885-1195-1-git-send-email-giometti@linux.it>
 <1266313885-1195-2-git-send-email-giometti@linux.it>
 <1266313885-1195-3-git-send-email-giometti@linux.it>
 <1266313885-1195-4-git-send-email-giometti@linux.it>
 <1266313885-1195-5-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 5/8] ldisc n_tty: add new method n_tty_inherit_ops()
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new method can be used to init a new struct tty_ldisc_ops as the
default tty_ldisc_N_TTY struct.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/char/n_tty.c |    9 +++++++++
 include/linux/tty.h  |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 2e50f4d..0f11375 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -48,6 +48,7 @@
 #include <linux/audit.h>
 #include <linux/file.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 
 #include <asm/system.h>
 
@@ -2091,3 +2092,11 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.receive_buf     = n_tty_receive_buf,
 	.write_wakeup    = n_tty_write_wakeup
 };
+
+void n_tty_inherit_ops(struct tty_ldisc_ops *ops)
+{
+	*ops = tty_ldisc_N_TTY;
+	ops->owner = NULL;
+	ops->refcount = ops->flags = 0;
+}
+EXPORT_SYMBOL_GPL(n_tty_inherit_ops);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index f0f43d0..5091438 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -485,6 +485,7 @@ extern void tty_ldisc_enable(struct tty_struct *tty);
 
 /* n_tty.c */
 extern struct tty_ldisc_ops tty_ldisc_N_TTY;
+extern void n_tty_inherit_ops(struct tty_ldisc_ops *ops);
 
 /* tty_audit.c */
 #ifdef CONFIG_AUDIT
-- 
1.6.3.3


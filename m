Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZDEQ5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZDEQ5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 12:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZDEQ5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 12:57:43 -0400
Received: from smtp4.welho.com ([213.243.153.38]:54539 "EHLO smtp4.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbZDEQ5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 12:57:42 -0400
X-Greylist: delayed 1460 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Apr 2009 12:57:42 EDT
Date: Sun, 5 Apr 2009 19:31:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make tty_driver_kref_get() static inline
Message-ID: <20090405163149.GB3718@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_driver_kref_get() should be static inline and not extern inline
(the latter even changed it's semantics in gcc >= 4.3).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 08e0883..4116817 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -310,7 +310,8 @@ extern void tty_set_operations(struct tty_driver *driver,
 extern struct tty_driver *tty_find_polling_driver(char *name, int *line);
 
 extern void tty_driver_kref_put(struct tty_driver *driver);
-extern inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
+
+static inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
 {
 	kref_get(&d->kref);
 	return d;


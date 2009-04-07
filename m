Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbZDGOlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbZDGOlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbZDGOk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:40:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43309 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756848AbZDGOk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:40:58 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/11] tty: Correct inline types for tty_driver_kref_get()
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 16:40:15 +0100
Message-ID: <20090407154008.17182.77930.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090407153824.17182.81672.stgit@t61.ukuu.org.uk>
References: <20090407153824.17182.81672.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

tty_driver_kref_get() should be static inline and not extern inline
(the latter even changed it's semantics in gcc >= 4.3).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 include/linux/tty_driver.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 8615d66..bcba84e 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -309,7 +309,8 @@ extern void tty_set_operations(struct tty_driver *driver,
 extern struct tty_driver *tty_find_polling_driver(char *name, int *line);
 
 extern void tty_driver_kref_put(struct tty_driver *driver);
-extern inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
+
+static inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
 {
 	kref_get(&d->kref);
 	return d;


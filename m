Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbXGKU4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbXGKU4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759630AbXGKU4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:56:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759232AbXGKU4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:56:43 -0400
Date: Wed, 11 Jul 2007 21:56:35 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [2.6.23 PATCH 01/18] dm: bio_list macro renaming
Message-ID: <20070711205635.GS24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alasdair G Kergon <agk@redhat.com>

Rename BIO_LIST() macro to DEFINE_BIO_LIST(), named similarly to
DEFINE_SPINLOCK().

Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-bio-list.h |    2 +-
 drivers/md/dm-delay.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/md/dm-bio-list.h
===================================================================
--- linux.orig/drivers/md/dm-bio-list.h	2007-07-11 21:37:33.000000000 +0100
+++ linux/drivers/md/dm-bio-list.h	2007-07-11 21:37:36.000000000 +0100
@@ -22,7 +22,7 @@ static inline int bio_list_empty(const s
 
 #define BIO_LIST_INIT { .head = NULL, .tail = NULL }
 
-#define BIO_LIST(bl) \
+#define DEFINE_BIO_LIST(bl) \
 	struct bio_list bl = BIO_LIST_INIT
 
 static inline void bio_list_init(struct bio_list *bl)
Index: linux/drivers/md/dm-delay.c
===================================================================
--- linux.orig/drivers/md/dm-delay.c	2007-07-11 21:37:33.000000000 +0100
+++ linux/drivers/md/dm-delay.c	2007-07-11 21:37:36.000000000 +0100
@@ -83,7 +83,7 @@ static struct bio *flush_delayed_bios(st
 	struct delay_info *delayed, *next;
 	unsigned long next_expires = 0;
 	int start_timer = 0;
-	BIO_LIST(flush_bios);
+	DEFINE_BIO_LIST(flush_bios);
 
 	mutex_lock(&delayed_bios_lock);
 	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {

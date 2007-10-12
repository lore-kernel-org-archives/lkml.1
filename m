Return-Path: <linux-kernel-owner+w=401wt.eu-S1762611AbXJLRVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762611AbXJLRVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762449AbXJLRTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:19:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761297AbXJLRTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:19:36 -0400
Date: Fri, 12 Oct 2007 18:19:28 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [2.6.24 PATCH 14/25] dm: bio_list macro renaming
Message-ID: <20071012171928.GZ24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
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

Remove BIO_LIST and DEFINE_BIO_LIST macros that gain us nothing
since contents are initialised to NULL.

Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-bio-list.h |    5 -----
 drivers/md/dm-delay.c    |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6.23/drivers/md/dm-bio-list.h
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-bio-list.h	2007-10-12 12:36:14.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-bio-list.h	2007-10-12 13:18:13.000000000 +0100
@@ -21,11 +21,6 @@ static inline int bio_list_empty(const s
 	return bl->head == NULL;
 }
 
-#define BIO_LIST_INIT { .head = NULL, .tail = NULL }
-
-#define BIO_LIST(bl) \
-	struct bio_list bl = BIO_LIST_INIT
-
 static inline void bio_list_init(struct bio_list *bl)
 {
 	bl->head = bl->tail = NULL;
Index: linux-2.6.23/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-delay.c	2007-10-12 13:15:34.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-delay.c	2007-10-12 13:18:13.000000000 +0100
@@ -83,7 +83,7 @@ static struct bio *flush_delayed_bios(st
 	struct dm_delay_info *delayed, *next;
 	unsigned long next_expires = 0;
 	int start_timer = 0;
-	BIO_LIST(flush_bios);
+	struct bio_list flush_bios = { };
 
 	mutex_lock(&delayed_bios_lock);
 	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {

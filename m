Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbYFXRaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbYFXRaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYFXRaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:30:08 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:48870 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbYFXRaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:30:06 -0400
Subject: [PATCH] fix2 to putback_lru_page()/unevictable page handling
	rework v3
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20080624114006.D81C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080624114006.D81C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Organization: HP/OSLO
Date: Tue, 24 Jun 2008 13:29:32 -0400
Message-Id: <1214328572.6563.31.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH revert shmem_lock() prototypes to return int

Against: 26-rc5-mm3 with Kosaki Motohiro's splitlru unevictable lru
fixes.

Fix to ﻿putback_lru_page()/unevictable page handling rework v3 patch.

The subject patch reverted a prior change to shmem_lock() to return a
struct address_space pointer back to returning an int.  This patch
updates the prototypes in mm.h to match.  

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 include/linux/mm.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.26-rc5-mm3/include/linux/mm.h
===================================================================
--- linux-2.6.26-rc5-mm3.orig/include/linux/mm.h	2008-06-24 12:54:41.000000000 -0400
+++ linux-2.6.26-rc5-mm3/include/linux/mm.h	2008-06-24 13:25:29.000000000 -0400
@@ -706,13 +706,12 @@ static inline int page_mapped(struct pag
 extern void show_free_areas(void);
 
 #ifdef CONFIG_SHMEM
-extern struct address_space *shmem_lock(struct file *file, int lock,
-					struct user_struct *user);
+extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
 #else
-static inline struct address_space *shmem_lock(struct file *file, int lock,
+static inline int shmem_lock(struct file *file, int lock,
 					struct user_struct *user)
 {
-	return NULL;
+	return 0;
 }
 #endif
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);



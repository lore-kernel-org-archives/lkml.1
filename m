Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbYEOPEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbYEOPEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbYEOPDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:03:36 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:20817 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbYEOPDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:03:33 -0400
Message-Id: <20080515150009.109105428@de.ibm.com>
References: <20080515145705.188435204@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 15 May 2008 16:57:12 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 07/11] s390dbf: Use const char * for dbf name.
Content-Disposition: inline; filename=007-cio-s390dbf.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

We should use const char * for passing the name of the debug feature
around since it will not be changed.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/debug.c |   20 ++++++++++----------
 include/asm-s390/debug.h |    4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

Index: quilt-2.6/arch/s390/kernel/debug.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/debug.c
+++ quilt-2.6/arch/s390/kernel/debug.c
@@ -71,7 +71,7 @@ static ssize_t debug_input(struct file *
 			size_t user_len, loff_t * offset);
 static int debug_open(struct inode *inode, struct file *file);
 static int debug_close(struct inode *inode, struct file *file);
-static debug_info_t*  debug_info_create(char *name, int pages_per_area,
+static debug_info_t *debug_info_create(const char *name, int pages_per_area,
 			int nr_areas, int buf_size, mode_t mode);
 static void debug_info_get(debug_info_t *);
 static void debug_info_put(debug_info_t *);
@@ -234,8 +234,8 @@ fail_malloc_areas:
  */
 
 static debug_info_t*
-debug_info_alloc(char *name, int pages_per_area, int nr_areas, int buf_size,
-		int level, int mode)
+debug_info_alloc(const char *name, int pages_per_area, int nr_areas,
+		 int buf_size, int level, int mode)
 {
 	debug_info_t* rc;
 
@@ -326,8 +326,8 @@ debug_info_free(debug_info_t* db_info){
  */
 
 static debug_info_t*
-debug_info_create(char *name, int pages_per_area, int nr_areas, int buf_size,
-		  mode_t mode)
+debug_info_create(const char *name, int pages_per_area, int nr_areas,
+		  int buf_size, mode_t mode)
 {
 	debug_info_t* rc;
 
@@ -684,9 +684,9 @@ debug_close(struct inode *inode, struct 
  * - Returns handle for debug area
  */
 
-debug_info_t *debug_register_mode(char *name, int pages_per_area, int nr_areas,
-				  int buf_size, mode_t mode, uid_t uid,
-				  gid_t gid)
+debug_info_t *debug_register_mode(const char *name, int pages_per_area,
+				  int nr_areas, int buf_size, mode_t mode,
+				  uid_t uid, gid_t gid)
 {
 	debug_info_t *rc = NULL;
 
@@ -722,8 +722,8 @@ EXPORT_SYMBOL(debug_register_mode);
  * - returns handle for debug area
  */
 
-debug_info_t *debug_register(char *name, int pages_per_area, int nr_areas,
-			     int buf_size)
+debug_info_t *debug_register(const char *name, int pages_per_area,
+			     int nr_areas, int buf_size)
 {
 	return debug_register_mode(name, pages_per_area, nr_areas, buf_size,
 				   S_IRUSR | S_IWUSR, 0, 0);
Index: quilt-2.6/include/asm-s390/debug.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/debug.h
+++ quilt-2.6/include/asm-s390/debug.h
@@ -120,10 +120,10 @@ debug_entry_t* debug_exception_common(de
 
 /* Debug Feature API: */
 
-debug_info_t* debug_register(char* name, int pages, int nr_areas,
+debug_info_t *debug_register(const char *name, int pages, int nr_areas,
                              int buf_size);
 
-debug_info_t *debug_register_mode(char *name, int pages, int nr_areas,
+debug_info_t *debug_register_mode(const char *name, int pages, int nr_areas,
 				  int buf_size, mode_t mode, uid_t uid,
 				  gid_t gid);
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


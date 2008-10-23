Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYJWPGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYJWPGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYJWPF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:05:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:33917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbYJWPF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:05:56 -0400
Message-Id: <20081023150549.569637960@marvin.suse.de>
User-Agent: quilt/0.47-12
Date: Thu, 23 Oct 2008 16:50:58 +0200
From: Daniel Gollub <dgollub@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: linux-man@vger.kernel.org
Cc: ltp-list@lists.sourceforge.net
Subject: [patch 3/3] [ltp] Remove testcase for "Buffer size is not positive" in kernel/syscalls/readlink/readlink03
References: <20081023145054.998439866@marvin.suse.de>
Content-Disposition: inline; filename=syscalls-readlink-bufsize-mismatch.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove testcase for "Buffer size is not positive" in testcase readlink03, since
buffer size argument is type of size_t (unsigned) and negative value are not
possible. With proposed sys_readlink modification a buffer size of 0 ends in a
return value of 0, not -1 anymore.

(This modification depends on man-pages and linux syscalls modifications,
 provided by this patch queue)

Signed-off-by: Daniel Gollub <dgollub@suse.de>


---
 testcases/kernel/syscalls/readlink/readlink03.c |    3 ---
 1 file changed, 3 deletions(-)

Index: ltp-full-20081017/testcases/kernel/syscalls/readlink/readlink03.c
===================================================================
--- ltp-full-20081017.orig/testcases/kernel/syscalls/readlink/readlink03.c
+++ ltp-full-20081017/testcases/kernel/syscalls/readlink/readlink03.c
@@ -25,8 +25,6 @@
  *   1) readlink(2) returns -1 and sets errno to EACCES if search/write
  *	permission is denied in the directory where the symbolic link
  *	resides.
- *   2) readlink(2) returns -1 and sets errno to EINVAL if the buffer size
- *	is not positive.
  *   3) readlink(2) returns -1 and sets errno to EINVAL if the specified
  *	file is not a symbolic link file.
  *   4) readlink(2) returns -1 and sets errno to ENAMETOOLONG if the 
@@ -119,7 +117,6 @@ struct test_case_t {		/* test case struc
 	int (*setupfunc)();
 } Test_cases[] = {
 	{ SYM_FILE1, "No Search permissions to process", EACCES, 1, setup1 },
-	{ SYM_FILE2, "Buffer size is not positive", EINVAL, -1, setup2 },
 	{ TEST_FILE2, "File is not symbolic link", EINVAL, 1, no_setup },
 	{ Longpathname, "Symlink path too long", ENAMETOOLONG, 1, lpath_setup },
 	{ "", "Symlink Pathname is empty", ENOENT, 1, no_setup },


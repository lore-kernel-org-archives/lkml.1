Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbXG0EPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbXG0EPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXG0EPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:15:11 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45583 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbXG0EPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:15:09 -0400
Date: Thu, 26 Jul 2007 21:18:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, jens.axboe@oracle.com
Subject: [PATCH] docbook: add pipes, other fixes
Message-Id: <20070726211818.ee87e773.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix some typos in pipe.c and splice.c.
Add pipes API to kernel-api.tmpl.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |   13 +++++++++++--
 fs/pipe.c                             |    2 +-
 fs/splice.c                           |    4 ++--
 3 files changed, 14 insertions(+), 5 deletions(-)

--- linux-2623-rc1g2.orig/fs/pipe.c
+++ linux-2623-rc1g2/fs/pipe.c
@@ -255,7 +255,7 @@ void generic_pipe_buf_get(struct pipe_in
 
 /**
  * generic_pipe_buf_confirm - verify contents of the pipe buffer
- * @pipe:	the pipe that the buffer belongs to
+ * @info:	the pipe that the buffer belongs to
  * @buf:	the buffer to confirm
  *
  * Description:
--- linux-2623-rc1g2.orig/fs/splice.c
+++ linux-2623-rc1g2/fs/splice.c
@@ -164,7 +164,7 @@ static const struct pipe_buf_operations 
  * @spd:	data to fill
  *
  * Description:
- *    @spd contains a map of pages and len/offset tupples, a long with
+ *    @spd contains a map of pages and len/offset tuples, along with
  *    the struct pipe_buf_operations associated with these pages. This
  *    function will link that data to the pipe.
  *
@@ -1000,7 +1000,7 @@ static long do_splice_to(struct file *in
  * Description:
  *    This is a special case helper to splice directly between two
  *    points, without requiring an explicit pipe. Internally an allocated
- *    pipe is cached in the process, and reused during the life time of
+ *    pipe is cached in the process, and reused during the lifetime of
  *    that process.
  *
  */
--- linux-2623-rc1g2.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2623-rc1g2/Documentation/DocBook/kernel-api.tmpl
@@ -704,14 +704,23 @@ X!Idrivers/video/console/fonts.c
 
   <chapter id="splice">
       <title>splice API</title>
-  <para>)
+  <para>
 	splice is a method for moving blocks of data around inside the
-	kernel, without continually transferring it between the kernel
+	kernel, without continually transferring them between the kernel
 	and user space.
   </para>
 !Iinclude/linux/splice.h
 !Ffs/splice.c
   </chapter>
 
+  <chapter id="pipes">
+      <title>pipes API</title>
+  <para>
+	Pipe interfaces are all for in-kernel (builtin image) use.
+	They are not exported for use by modules.
+  </para>
+!Iinclude/linux/pipe_fs_i.h
+!Ffs/pipe.c
+  </chapter>
 
 </book>

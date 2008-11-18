Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbYKRUkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbYKRUkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYKRUkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:40:04 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:19204 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYKRUkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:40:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=posQG04ApligYMs4SjtRW5DZwJ8R3oFpik1jvhmrnrCwhCN2tjcRl0k0KR95JmtRKc
         VuKl+dxSoFjUs772IrIZL3CvakU3TccWsgYwK+Ao9SF5zXY79mvlokMVus5aRo9uoKTk
         0K9dQiccXNCjjIHq0QsIWvUQ1VUOk45Q1CNAI=
Message-ID: <49232819.3020908@gmail.com>
Date: Tue, 18 Nov 2008 15:39:53 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: mtk.manpages@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch] Fix type errors in inotify interfaces
References: <4923230D.8090301@gmail.com> <cfd18e0f0811181222y4cba081m18fc5cf86512b85f@mail.gmail.com>
In-Reply-To: <cfd18e0f0811181222y4cba081m18fc5cf86512b85f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich,

Below are the changes that I believe are required in glibc.

Thanks,

Michael


diff -ruN glibc-2.9/sysdeps/unix/sysv/linux/alpha/sys/inotify.h glibc-2.9-mod/sysdeps/unix/sysv/linux/alpha/sys/inotify.h
--- glibc-2.9/sysdeps/unix/sysv/linux/alpha/sys/inotify.h	2008-07-24 23:43:59.000000000 -0500
+++ glibc-2.9-mod/sysdeps/unix/sysv/linux/alpha/sys/inotify.h	2008-11-18 15:30:53.000000000 -0500
@@ -35,7 +35,7 @@
 /* Structure describing an inotify event.  */
 struct inotify_event
 {
-  int wd;		/* Watch descriptor.  */
+  int32_t wd;		/* Watch descriptor.  */
   uint32_t mask;	/* Watch mask.  */
   uint32_t cookie;	/* Cookie to synchronize two events.  */
   uint32_t len;		/* Length (including NULs) of name.  */
@@ -98,7 +98,7 @@
   __THROW;
 
 /* Remove the watch specified by WD from the inotify instance FD.  */
-extern int inotify_rm_watch (int __fd, uint32_t __wd) __THROW;
+extern int inotify_rm_watch (int __fd, int __wd) __THROW;
 
 __END_DECLS
 
diff -ruN glibc-2.9/sysdeps/unix/sysv/linux/sparc/sys/inotify.h glibc-2.9-mod/sysdeps/unix/sysv/linux/sparc/sys/inotify.h
--- glibc-2.9/sysdeps/unix/sysv/linux/sparc/sys/inotify.h	2008-07-24 23:48:03.000000000 -0500
+++ glibc-2.9-mod/sysdeps/unix/sysv/linux/sparc/sys/inotify.h	2008-11-18 15:31:08.000000000 -0500
@@ -35,7 +35,7 @@
 /* Structure describing an inotify event.  */
 struct inotify_event
 {
-  int wd;		/* Watch descriptor.  */
+  int32_t wd;		/* Watch descriptor.  */
   uint32_t mask;	/* Watch mask.  */
   uint32_t cookie;	/* Cookie to synchronize two events.  */
   uint32_t len;		/* Length (including NULs) of name.  */
@@ -98,7 +98,7 @@
   __THROW;
 
 /* Remove the watch specified by WD from the inotify instance FD.  */
-extern int inotify_rm_watch (int __fd, uint32_t __wd) __THROW;
+extern int inotify_rm_watch (int __fd, int __wd) __THROW;
 
 __END_DECLS
 
diff -ruN glibc-2.9/sysdeps/unix/sysv/linux/sys/inotify.h glibc-2.9-mod/sysdeps/unix/sysv/linux/sys/inotify.h
--- glibc-2.9/sysdeps/unix/sysv/linux/sys/inotify.h	2008-07-24 23:50:41.000000000 -0500
+++ glibc-2.9-mod/sysdeps/unix/sysv/linux/sys/inotify.h	2008-11-18 15:31:23.000000000 -0500
@@ -35,7 +35,7 @@
 /* Structure describing an inotify event.  */
 struct inotify_event
 {
-  int wd;		/* Watch descriptor.  */
+  int32_t wd;		/* Watch descriptor.  */
   uint32_t mask;	/* Watch mask.  */
   uint32_t cookie;	/* Cookie to synchronize two events.  */
   uint32_t len;		/* Length (including NULs) of name.  */
@@ -98,7 +98,7 @@
   __THROW;
 
 /* Remove the watch specified by WD from the inotify instance FD.  */
-extern int inotify_rm_watch (int __fd, uint32_t __wd) __THROW;
+extern int inotify_rm_watch (int __fd, int __wd) __THROW;
 
 __END_DECLS
 

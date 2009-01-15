Return-Path: <linux-kernel-owner+w=401wt.eu-S934720AbZAOW2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720AbZAOW2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933832AbZAOWCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:51 -0500
Received: from kroah.org ([198.145.64.141]:38510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932417AbZAOWCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:38 -0500
Date: Thu, 15 Jan 2009 14:00:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 46/85] [PATCH 26/44] [CVE-2009-0029] System call wrappers
	part 16
Message-ID: <20090115220027.GU17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0026--CVE-2009-0029-System-call-wrappers-part-16.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 002c8976ee537724b20a5e179d9b349309438836 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/aio.c        |   22 +++++++++++-----------
 fs/locks.c      |    2 +-
 fs/open.c       |    2 +-
 fs/read_write.c |    4 ++--
 fs/stat.c       |    4 ++--
 5 files changed, 17 insertions(+), 17 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1258,7 +1258,7 @@ static void io_destroy(struct kioctx *io
  *	pointer is passed for ctxp.  Will fail with -ENOSYS if not
  *	implemented.
  */
-asmlinkage long sys_io_setup(unsigned nr_events, aio_context_t __user *ctxp)
+SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
 {
 	struct kioctx *ioctx = NULL;
 	unsigned long ctx;
@@ -1296,7 +1296,7 @@ out:
  *	implemented.  May fail with -EFAULT if the context pointed to
  *	is invalid.
  */
-asmlinkage long sys_io_destroy(aio_context_t ctx)
+SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx);
 	if (likely(NULL != ioctx)) {
@@ -1650,8 +1650,8 @@ out_put_req:
  *	are available to queue any iocbs.  Will return 0 if nr is 0.  Will
  *	fail with -ENOSYS if not implemented.
  */
-asmlinkage long sys_io_submit(aio_context_t ctx_id, long nr,
-			      struct iocb __user * __user *iocbpp)
+SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
+		struct iocb __user * __user *, iocbpp)
 {
 	struct kioctx *ctx;
 	long ret = 0;
@@ -1725,8 +1725,8 @@ static struct kiocb *lookup_kiocb(struct
  *	invalid.  May fail with -EAGAIN if the iocb specified was not
  *	cancelled.  Will fail with -ENOSYS if not implemented.
  */
-asmlinkage long sys_io_cancel(aio_context_t ctx_id, struct iocb __user *iocb,
-			      struct io_event __user *result)
+SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
+		struct io_event __user *, result)
 {
 	int (*cancel)(struct kiocb *iocb, struct io_event *res);
 	struct kioctx *ctx;
@@ -1787,11 +1787,11 @@ asmlinkage long sys_io_cancel(aio_contex
  *	will be updated if not NULL and the operation blocks.  Will fail
  *	with -ENOSYS if not implemented.
  */
-asmlinkage long sys_io_getevents(aio_context_t ctx_id,
-				 long min_nr,
-				 long nr,
-				 struct io_event __user *events,
-				 struct timespec __user *timeout)
+SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
+		long, min_nr,
+		long, nr,
+		struct io_event __user *, events,
+		struct timespec __user *, timeout)
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx_id);
 	long ret = -EINVAL;
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1564,7 +1564,7 @@ EXPORT_SYMBOL(flock_lock_file_wait);
  *	%LOCK_MAND can be combined with %LOCK_READ or %LOCK_WRITE to allow other
  *	processes read and write access respectively.
  */
-asmlinkage long sys_flock(unsigned int fd, unsigned int cmd)
+SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
 {
 	struct file *filp;
 	struct file_lock *lock;
--- a/fs/open.c
+++ b/fs/open.c
@@ -1081,7 +1081,7 @@ asmlinkage long sys_openat(int dfd, cons
  * For backward compatibility?  Maybe this should be moved
  * into arch/i386 instead?
  */
-asmlinkage long sys_creat(const char __user * pathname, int mode)
+SYSCALL_DEFINE2(creat, const char __user *, pathname, int, mode)
 {
 	return sys_open(pathname, O_CREAT | O_WRONLY | O_TRUNC, mode);
 }
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -793,7 +793,7 @@ out:
 	return retval;
 }
 
-asmlinkage long sys_sendfile(int out_fd, int in_fd, off_t __user *offset, size_t count)
+SYSCALL_DEFINE4(sendfile, int, out_fd, int, in_fd, off_t __user *, offset, size_t, count)
 {
 	loff_t pos;
 	off_t off;
@@ -812,7 +812,7 @@ asmlinkage long sys_sendfile(int out_fd,
 	return do_sendfile(out_fd, in_fd, NULL, count, 0);
 }
 
-asmlinkage long sys_sendfile64(int out_fd, int in_fd, loff_t __user *offset, size_t count)
+SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd, loff_t __user *, offset, size_t, count)
 {
 	loff_t pos;
 	ssize_t ret;
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -320,8 +320,8 @@ asmlinkage long sys_readlinkat(int dfd, 
 	return error;
 }
 
-asmlinkage long sys_readlink(const char __user *path, char __user *buf,
-				int bufsiz)
+SYSCALL_DEFINE3(readlink, const char __user *, path, char __user *, buf,
+		int, bufsiz)
 {
 	return sys_readlinkat(AT_FDCWD, path, buf, bufsiz);
 }


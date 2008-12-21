Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYLUU76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYLUU76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 15:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYLUU7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 15:59:47 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57642 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbYLUU7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 15:59:45 -0500
Date: Sun, 21 Dec 2008 21:59:41 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: mtk.manpages@gmail.com
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>
Subject: [PATCH v2] add man-page for pthread_mutexattr_setrobust_np()
Message-ID: <20081221205941.GA11805@Chamillionaire.breakpoint.cc>
References: <20081201213458.GA18973@Chamillionaire.breakpoint.cc> <cfd18e0f0812070844t349b6026n6e2b0a2b4826fa66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <cfd18e0f0812070844t349b6026n6e2b0a2b4826fa66@mail.gmail.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Kerrisk | 2008-12-07 11:44:54 [-0500]:

>Sebastian,
Michael,

>I will have more comments later, but a few quick comments now.  Could
>you revise your page in the light of these comments?
Yup. Here is version two. I somehow mixed up the IEEE man-pages with
yours. So first I didn't understand most of you comments :) Once I
figured that out I tried to address all of your comments and I've also
rephrased everything. Be prepared :)

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 man3/pthread_mutex_consistent_np.3    |    1 +
 man3/pthread_mutexattr_getrobust_np.3 |    1 +
 man3/pthread_mutexattr_setrobust_np.3 |  255 +++++++++++++++++++++++++++++++++
 3 files changed, 257 insertions(+), 0 deletions(-)
 create mode 100644 man3/pthread_mutex_consistent_np.3
 create mode 100644 man3/pthread_mutexattr_getrobust_np.3
 create mode 100644 man3/pthread_mutexattr_setrobust_np.3

diff --git a/man3/pthread_mutex_consistent_np.3 b/man3/pthread_mutex_consistent_np.3
new file mode 100644
index 0000000..a92edb9
--- /dev/null
+++ b/man3/pthread_mutex_consistent_np.3
@@ -0,0 +1 @@
+.so man3/pthread_mutexattr_setrobust_np.3
diff --git a/man3/pthread_mutexattr_getrobust_np.3 b/man3/pthread_mutexattr_getrobust_np.3
new file mode 100644
index 0000000..a92edb9
--- /dev/null
+++ b/man3/pthread_mutexattr_getrobust_np.3
@@ -0,0 +1 @@
+.so man3/pthread_mutexattr_setrobust_np.3
diff --git a/man3/pthread_mutexattr_setrobust_np.3 b/man3/pthread_mutexattr_setrobust_np.3
new file mode 100644
index 0000000..34dbd6e
--- /dev/null
+++ b/man3/pthread_mutexattr_setrobust_np.3
@@ -0,0 +1,255 @@
+.\" Copyright (c) 2008 Sebastian Andrzej Siewior
+.\" Copyright (c) 2008 Linux Foundation, Michael Kerrisk
+.\"    <mtk.manpages@gmail.com>
+.\"
+.\" Permission is granted to make and distribute verbatim copies of this
+.\" manual provided the copyright notice and this permission notice are
+.\" preserved on all copies.
+.\"
+.\" Permission is granted to copy and distribute modified versions of this
+.\" manual under the conditions for verbatim copying, provided that the
+.\" entire resulting derived work is distributed under the terms of a
+.\" permission notice identical to this one.
+.\"
+.\" Since the Linux kernel and libraries are constantly changing, this
+.\" manual page may be incorrect or out-of-date.  The author(s) assume no
+.\" responsibility for errors or omissions, or for damages resulting from
+.\" the use of the information contained herein.  The author(s) may not
+.\" have taken the same level of care in the production of this manual,
+.\" which is licensed free of charge, as they might when working
+.\" professionally.
+.\"
+.\" Formatted or processed versions of this manual, if unaccompanied by
+.\" the source, must acknowledge the copyright and authors of this work.
+
+.TH "ROBUST MUTEXES" 3 2008-12-18 "GNU C Library" "Linux Programmer's Manual"
+.SH NAME
+pthread_mutexattr_setrobust_np, pthread_mutexattr_getrobust_np \- set or get
+the robustness of a mutex.
+.SH SYNOPSIS
+.nf
+.B #define _GNU_SOURCE
+.B #include <pthread.h>
+.sp
+.BI "int pthread_mutexattr_getrobust_np(pthread_mutexattr_t " *attr ",
+.BI "                    int " robustness ");"
+.BI "int pthread_mutexattr_setrobust_np(pthread_mutexattr_t " *attr ",
+.BI "                    int " robustness ");"
+.BI "int pthread_mutex_consistent_np(pthread_mutex_t " *mutex ");"
+.fi
+.sp
+Compile and link with \fI\-pthread\fP.
+.SH DESCRIPTION
+The
+.BR pthread_mutexattr_getrobust_np ()
+sets the robustness of the mutex attribute object referred to by
+.I attr
+to the value specified in
+.IR robustness .
+The
+.BR pthread_mutexattr_getrobust_np ()
+retrieves the current values of robustness of mutex attribute object referred
+to by
+.IR attr .
+The following values may be specified in
+.IR robustness :
+.TP
+.B PTHREAD_MUTEX_STALLED_NP
+Mutexes created using
+.I attr
+will stall if the owner dies while owning the lock.
+.PP
+The default setting of the robustness attribute in a newly initialized mutex
+object is
+.BR PTHREAD_MUTEX_STALLED_NP .
+.TP
+.B PTHREAD_MUTEX_ROBUST_NP
+Mutexes created using
+.I attr
+will be reboots. If the owner dies while holding the lock
+.BR pthread_mutex_lock ()
+will return
+.BR EOWNERDEAD
+.B and
+the caller is holding lock.
+This return value shall signalize the caller that the resource which is
+protected by the mutex may be in an inconsistent state and should be verified
+before used.
+Once the lock holder sanitized the protected resource he should invoke
+.BR pthread_mutex_consistent_np ()
+on the mutex object to mark that mutex as consistent.
+If this is not done, future locking requests will return
+.B EOWNERDEAD
+although the previous owner did not die.
+.SH "RETURN VALUE"
+On success, these functions return 0;
+on error, they return a non-zero error number.
+.SH ERRORS
+.BR pthread_mutexattr_setrobust_np ()
+can fail with the following error:
+.TP
+.B EINVAL
+Invalid value in
+.IR robustness .
+.PP
+.BR pthread_mutexattr_getrobust_np ()
+can fail with the following error:
+.TP
+.B EINVAL
+Invalid value in
+.IR robustness .
+.PP
+.BR pthread_mutex_consistent_np ()
+can fail with the following error:
+.TP
+.B EINVAL
+The mutex object specified by
+.I mutex
+is either not
+.B PTHREAD_MUTEX_ROBUST_NP
+or is in a consistent state.
+.PP
+.SH EXAMPLE
+The code example shows how to share a lock between two applications without
+System V IPC.
+An advantage over System V semaphores is that the kernel is not invoked in
+case the lock is not hold.
+If one of the applications dies while holding the lock or the system reboots
+unexpectedly, the new owner of lock marks the lock state consistent.
+In this example the lock owner does not need to perform any validation of the
+resource protected by the lock.
+
+.nf
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+static const char *lock_name = "/dev/shm/limi_lock";
+static pthread_mutex_t *limi_mutex;
+
+static int open_existing_lock(void)
+{
+    int fd;
+    int ret;
+    struct stat buf;
+    int retry = 5;
+
+    fd = open(lock_name, O_RDWR);
+    if (fd < 0)
+        return fd;
+    do {
+        ret = fstat(fd, &buf);
+        if (ret < 0)
+            return ret;
+
+        if (buf.st_size == sizeof(*limi_mutex))
+            return fd;
+
+        close(fd);
+        sleep(1);
+        retry\-\-;
+    } while (retry);
+
+    close(fd);
+    return \-1;
+}
+
+static int create_new_lock(void)
+{
+    int fd;
+    pthread_mutex_t cmutex = PTHREAD_MUTEX_INITIALIZER;
+    pthread_mutexattr_t attr;
+    int ret;
+
+    pthread_mutexattr_init(&attr);
+    pthread_mutexattr_setrobust_np(&attr, PTHREAD_MUTEX_ROBUST_NP);
+    pthread_mutex_init(&cmutex, &attr);
+
+    fd = open(lock_name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR |
+            S_IRGRP | S_IWGRP);
+    if (fd < 0)
+        return fd;
+
+    ret = write(fd, &cmutex, sizeof(cmutex));
+    if (ret < 0) {
+        fprintf(stderr, "Write to %s failed: %s\\n",
+                lock_name, strerror(errno));
+        exit(1);
+    }
+    return fd;
+}
+
+void limi_lock_init(void)
+{
+    void *limi_lock_mmap;
+    int lock_fd;
+
+    lock_fd = open_existing_lock();
+    if (lock_fd < 0) {
+        lock_fd = create_new_lock();
+        if (lock_fd < 0) {
+            lock_fd = open_existing_lock();
+            if (lock_fd < 0) {
+                fprintf(stderr, "Can't open %s: %s\\n",
+                        lock_name, strerror(errno));
+                exit(1);
+            }
+        }
+    }
+
+    limi_lock_mmap = mmap(NULL, sizeof(*limi_mutex),
+            PROT_READ | PROT_WRITE, MAP_SHARED, lock_fd, 0);
+    close(lock_fd);
+    if (limi_lock_mmap == MAP_FAILED) {
+        fprintf(stderr, "failed to mmap limi lock: %s\\n",
+                strerror(errno));
+        exit(1);
+    }
+    limi_mutex = limi_lock_mmap;
+}
+
+void limi_lock(void)
+{
+    int ret;
+
+    ret = pthread_mutex_lock(limi_mutex);
+    if (!ret)
+        return;
+
+    if (ret == EOWNERDEAD) {
+        pthread_mutex_consistent_np(limi_mutex);
+        return;
+    }
+
+    fprintf(stderr, "Can not grab lock: %s\\n", strerror(ret));
+    exit(1);
+}
+
+void limi_unlock(void)
+{
+    int ret;
+
+    ret = pthread_mutex_unlock(limi_mutex);
+    if (!ret)
+        return;
+
+    fprintf(stderr, "Can not unlock: %s\\n", strerror(ret));
+    exit(1);
+}
+
+.fi
+.SH "SEE ALSO"
+.BR pthread_mutex_create (3),
+.BR pthread_mutexattr_init (3),
+.BR pthread_mutex_lock (3),
+.BR pthread_mutex_unlock (3)
-- 
1.6.0.4


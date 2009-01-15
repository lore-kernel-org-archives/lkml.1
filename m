Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbZAOWiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbZAOWiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933466AbZAOWDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:41 -0500
Received: from kroah.org ([198.145.64.141]:38896 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933995AbZAOWDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:38 -0500
Date: Thu, 15 Jan 2009 14:01:25 -0800
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
Subject: [patch 63/85] [PATCH 43/44] [CVE-2009-0029] System call wrappers
Message-ID: <20090115220125.GL17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0043--CVE-2009-0029-System-call-wrappers-part-33.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 2b66421995d2e93c9d1a0111acf2581f8529c6e5 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/pipe.c                |    2 +-
 include/linux/syscalls.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1067,7 +1067,7 @@ SYSCALL_DEFINE2(pipe2, int __user *, fil
 	return error;
 }
 
-asmlinkage long sys_pipe(int __user *fildes)
+SYSCALL_DEFINE1(pipe, int __user *, fildes)
 {
 	return sys_pipe2(fildes, 0);
 }
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -686,6 +686,7 @@ asmlinkage long sys_ppoll(struct pollfd 
 			  struct timespec __user *, const sigset_t __user *,
 			  size_t);
 asmlinkage long sys_pipe2(int __user *, int);
+asmlinkage long sys_pipe(int __user *);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 


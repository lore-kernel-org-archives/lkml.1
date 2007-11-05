Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbXKEXTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbXKEXTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXKEXTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:19:22 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22103 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXKEXTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:19:21 -0500
Message-ID: <472FA4F7.4090705@msgid.tls.msk.ru>
Date: Tue, 06 Nov 2007 02:19:19 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Phillip Lougher <phillip@lougher.demon.co.uk>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANN] Squashfs 3.3 released
References: <472EFACA.1090308@lougher.demon.co.uk>
In-Reply-To: <472EFACA.1090308@lougher.demon.co.uk>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Lougher wrote:
> Hi,
> 
> I'm pleased to announce another release of Squashfs.  This is the 22nd
> release in just over five years.

Thanks Phillip.

A tiny bug[fix] I always forgot to send...  In fs/squashfs/inode.c,
constants TASK_UNINTERRUPTIBLE and TASK_INTERRUPTIBLE are used, but
they aren't sometimes defined (declared in linux/sched.h):

  CC [M]  fs/squashfs/inode.o
fs/squashfs/inode.c: In function 'squashfs_get_cached_block':
fs/squashfs/inode.c:367: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
fs/squashfs/inode.c:367: error: (Each undeclared identifier is reported only once
fs/squashfs/inode.c:367: error: for each function it appears in.)
fs/squashfs/inode.c:367: warning: implicit declaration of function 'schedule'
fs/squashfs/inode.c:404: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
fs/squashfs/inode.c: In function 'release_cached_fragment':
fs/squashfs/inode.c:499: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
fs/squashfs/inode.c:499: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
fs/squashfs/inode.c: In function 'get_cached_fragment':
fs/squashfs/inode.c:522: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
fs/squashfs/inode.c:559: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)

I'm not exactly sure which config option is "at blame"
(this is an i486-based UP generic-hardware config), but
I'm not interested to know, either.  The following
trivial patch fixes it once for all.

--- linux-2.6.22.orig/fs/squashfs/inode.c       2007-07-12 14:57:22.000000000 +0400
+++ linux-2.6.22/fs/squashfs/inode.c    2007-07-12 14:57:53.000000000 +0400
@@ -31,6 +31,7 @@
 #include <linux/vfs.h>
 #include <linux/vmalloc.h>
+#include <linux/sched.h>
 #include <linux/smp_lock.h>

 #include "squashfs.h"


It was needed for v3.2 too.

Thanks.

/mjt

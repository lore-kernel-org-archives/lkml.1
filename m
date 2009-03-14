Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbZCNAVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbZCNAVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZCNAS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:29 -0400
Received: from kroah.org ([198.145.64.141]:46656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752497AbZCNAS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:39 2009
Message-Id: <20090314000739.850067727@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:16 -0700
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
       alan@lxorguk.ukuu.org.uk, Paul Turner <pjt@google.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 08/96] vfs: separate FMODE_PREAD/FMODE_PWRITE into separate flags
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Turner <pjt@google.com>

commit 55ec82176eca52e4e0530a82a0eb59160a1a95a1 upstream.

Separate FMODE_PREAD and FMODE_PWRITE into separate flags to reflect the
reality that the read and write paths may have independent restrictions.

A git grep verifies that these flags are always cleared together so this
new behavior will only apply to interfaces that change to clear flags
individually.

This is required for "seq_file: properly cope with pread", a post-2.6.25
regression fix.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Paul Turner <pjt@google.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc:  Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/fs.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -63,17 +63,23 @@ extern int dir_notify_enable;
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
 
+/*
+ * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
+ * to O_WRONLY and O_RDWR via the strange trick in __dentry_open()
+ */
+
 /* file is open for reading */
 #define FMODE_READ		(1)
 /* file is open for writing */
 #define FMODE_WRITE		(2)
 /* file is seekable */
 #define FMODE_LSEEK		(4)
-/* file can be accessed using pread/pwrite */
+/* file can be accessed using pread */
 #define FMODE_PREAD		(8)
-#define FMODE_PWRITE		FMODE_PREAD	/* These go hand in hand */
+/* file can be accessed using pwrite */
+#define FMODE_PWRITE		(16)
 /* File is opened for execution with sys_execve / sys_uselib */
-#define FMODE_EXEC		(16)
+#define FMODE_EXEC		(32)
 
 #define RW_MASK		1
 #define RWA_MASK	2



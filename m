Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZKNHBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZKNHBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 02:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZKNHBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 02:01:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44184 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZKNHBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 02:01:30 -0500
Date: Sat, 14 Nov 2009 18:01:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Joseph S. Myers" <joseph@codesourcery.com>, linux-api@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <onestero@redhat.com>,
       Stephane Eranian <eranian@googlemail.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@gmail.com>
Subject: [PATCH] fcntl: use architecture independent values for new fcntl
 operations
Message-Id: <20091114180131.da95d2a1.sfr@canb.auug.org.au>
In-Reply-To: <20091113103257.1f4f6e12.sfr@canb.auug.org.au>
References: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
	<1254691822.21044.9.camel@laptop>
	<20091030161320.17d07dc9.sfr@canb.auug.org.au>
	<20091030162906.fbc1c40b.sfr@canb.auug.org.au>
	<20091113103257.1f4f6e12.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what F_LINUX_SPECIFIC_BASE was meant for.

These values were only introduced during this release cycle, so it is
still early enough to get them right.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/alpha/include/asm/fcntl.h  |    2 --
 arch/parisc/include/asm/fcntl.h |    2 --
 include/asm-generic/fcntl.h     |   14 --------------
 include/linux/fcntl.h           |   12 ++++++++++++
 4 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/alpha/include/asm/fcntl.h b/arch/alpha/include/asm/fcntl.h
index 73126e4..25da001 100644
--- a/arch/alpha/include/asm/fcntl.h
+++ b/arch/alpha/include/asm/fcntl.h
@@ -26,8 +26,6 @@
 #define F_GETOWN	6	/*  for sockets. */
 #define F_SETSIG	10	/*  for sockets. */
 #define F_GETSIG	11	/*  for sockets. */
-#define F_SETOWN_EX	15
-#define F_GETOWN_EX	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		1
diff --git a/arch/parisc/include/asm/fcntl.h b/arch/parisc/include/asm/fcntl.h
index 5f39d55..1e1c824 100644
--- a/arch/parisc/include/asm/fcntl.h
+++ b/arch/parisc/include/asm/fcntl.h
@@ -28,8 +28,6 @@
 #define F_SETOWN	12	/*  for sockets. */
 #define F_SETSIG	13	/*  for sockets. */
 #define F_GETSIG	14	/*  for sockets. */
-#define F_GETOWN_EX	15
-#define F_SETOWN_EX	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		01
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index cd2d789..8ec0716 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -82,20 +82,6 @@
 #endif
 #endif
 
-#ifndef F_SETOWN_EX
-#define F_SETOWN_EX	15
-#define F_GETOWN_EX	16
-#endif
-
-#define F_OWNER_TID	0
-#define F_OWNER_PID	1
-#define F_OWNER_GID	2
-
-struct f_owner_ex {
-	int	type;
-	pid_t	pid;
-};
-
 /* for F_[GET|SET]FL */
 #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
 
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 8603740..b34c41d 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -40,6 +40,18 @@
                                            unlinking file.  */
 #define AT_SYMLINK_FOLLOW	0x400   /* Follow symbolic links.  */
 
+#define F_SETOWN_EX	(F_LINUX_SPECIFIC_BASE + 7)
+#define F_GETOWN_EX	(F_LINUX_SPECIFIC_BASE + 8)
+
+#define F_OWNER_TID	0
+#define F_OWNER_PID	1
+#define F_OWNER_GID	2
+
+struct f_owner_ex {
+	int	type;
+	pid_t	pid;
+};
+
 #ifdef __KERNEL__
 
 #ifndef force_o_largefile
-- 
1.6.5.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

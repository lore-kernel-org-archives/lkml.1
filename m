Return-Path: <linux-kernel-owner+w=401wt.eu-S1764611AbZCTXlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764611AbZCTXlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763037AbZCTXZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:25:05 -0400
Received: from kroah.org ([198.145.64.141]:48891 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763007AbZCTXZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:25:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:29 2009
Message-Id: <20090320222929.694116500@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:53 -0700
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
       alan@lxorguk.ukuu.org.uk, Randy Dunlap <randy.dunlap@oracle.com>
Subject: [patch 43/43] menu: fix embedded menu snafu
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=menu-fix-embedded-menu-snafu.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Randy Dunlap <randy.dunlap@oracle.com>

commit b943c460ff8556a193b28e2145b513f8b978e869 upstream.

The COMPAT_BRK kconfig symbol does not depend on EMBEDDED, but it is in
the midst of the EMBEDDED menu symbols, so it mucks up the EMBEDDED menu.
Fix by moving it to just after all of the EMBEDDED menu symbols.  Also,
ANON_INODES has a similar problem, so move it to just above the EMBEDDED
menu items since it is used in the EMBEDDED menu.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/Kconfig |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -538,6 +538,9 @@ config CC_OPTIMIZE_FOR_SIZE
 config SYSCTL
 	bool
 
+config ANON_INODES
+	bool
+
 menuconfig EMBEDDED
 	bool "Configure standard kernel features (for small systems)"
 	help
@@ -643,18 +646,6 @@ config PCSPKR_PLATFORM
           This option allows to disable the internal PC-Speaker
           support, saving some memory.
 
-config COMPAT_BRK
-	bool "Disable heap randomization"
-	default y
-	help
-	  Randomizing heap placement makes heap exploits harder, but it
-	  also breaks ancient binaries (including anything libc5 based).
-	  This option changes the bootup default to heap randomization
-	  disabled, and can be overriden runtime by setting
-	  /proc/sys/kernel/randomize_va_space to 2.
-
-	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
-
 config BASE_FULL
 	default y
 	bool "Enable full-sized data structures for core" if EMBEDDED
@@ -672,9 +663,6 @@ config FUTEX
 	  support for "fast userspace mutexes".  The resulting kernel may not
 	  run glibc-based applications correctly.
 
-config ANON_INODES
-	bool
-
 config EPOLL
 	bool "Enable eventpoll support" if EMBEDDED
 	default y
@@ -760,6 +748,18 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+config COMPAT_BRK
+	bool "Disable heap randomization"
+	default y
+	help
+	  Randomizing heap placement makes heap exploits harder, but it
+	  also breaks ancient binaries (including anything libc5 based).
+	  This option changes the bootup default to heap randomization
+	  disabled, and can be overriden runtime by setting
+	  /proc/sys/kernel/randomize_va_space to 2.
+
+	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
+
 choice
 	prompt "Choose SLAB allocator"
 	default SLUB



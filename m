Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbZCCAew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbZCCAew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbZCCAen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:34:43 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:33208 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZCCAem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:34:42 -0500
Message-ID: <49AC7B50.1060104@oracle.com>
Date: Mon, 02 Mar 2009 16:35:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] menu: fix embedded menu snafu
References: <20090302141406.13d5ef1f.randy.dunlap@oracle.com> <20090302161602.a4eea5d9.akpm@linux-foundation.org> <alpine.LFD.2.00.0903021619270.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903021619270.3111@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49AC7AF8.0219:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 2 Mar 2009, Andrew Morton wrote:
>> This patch causes weird unintended breakage, methinks.
> 
> Damn, you're right. It looked obvious, so I already applied it, but I 
> clearly shouldn't have.
> 
> The whole "if EMBEDDED" thing is totally wrong, because those config 
> options  very much_do_ exist even when non-embedded, it's just that then 
> they always take their default valies.


Crud.  OK, v2, probably just for Andrew for now (?).




From: Randy Dunlap <randy.dunlap@oracle.com>

The COMPAT_BRK kconfig symbol does not depend on EMBEDDED,
but it is in the midst of the EMBEDDED menu symbols, so it mucks
up the EMBEDDED menu.  Fix by moving it to just after all of
the EMBEDDED menu symbols.  Also, ANON_INODES has a similar
problem, so move it to just above the EMBEDDED menu items
since it is used in the EMBEDDED menu.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 init/Kconfig |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- linux-2.6.29-rc6-git5.orig/init/Kconfig
+++ linux-2.6.29-rc6-git5/init/Kconfig
@@ -675,6 +675,9 @@ config CC_OPTIMIZE_FOR_SIZE
 config SYSCTL
 	bool
 
+config ANON_INODES
+	bool
+
 menuconfig EMBEDDED
 	bool "Configure standard kernel features (for small systems)"
 	help
@@ -780,18 +783,6 @@ config PCSPKR_PLATFORM
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
@@ -809,9 +800,6 @@ config FUTEX
 	  support for "fast userspace mutexes".  The resulting kernel may not
 	  run glibc-based applications correctly.
 
-config ANON_INODES
-	bool
-
 config EPOLL
 	bool "Enable eventpoll support" if EMBEDDED
 	default y
@@ -897,6 +885,18 @@ config SLUB_DEBUG
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

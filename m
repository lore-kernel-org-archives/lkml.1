Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbXLVT2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbXLVT2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 14:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXLVT2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 14:28:23 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3456 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbXLVT2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 14:28:22 -0500
Subject: Re: [PATCH 1/3] Remove unused dependency
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       trivial@kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
In-Reply-To: <20071222143128.GA24659@uranus.ravnborg.org>
References: <1198306931-5258-1-git-send-email-joe@perches.com>
	 <1198306931-5258-2-git-send-email-joe@perches.com>
	 <20071222083323.GA22653@uranus.ravnborg.org>
	 <1198313412.4895.24.camel@localhost>
	 <20071222143128.GA24659@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 22 Dec 2007 11:28:11 -0800
Message-Id: <1198351691.4895.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-22 at 15:31 +0100, Sam Ravnborg wrote:
> I looked at how inflate was used:
>  
> $ grep inflate */boot/Makefile
> alpha/boot/Makefile:$(obj)/misc.o: lib/inflate.c
> => redundandt dependency, can be deleted
> A cleanup of all this is needed.

Perhaps it's better to move lib/inflate.c to the
include path (include/lib ?) and convert the files that
#include "(../)*lib/inflate.c" to
#include <lib/inflate.c>?


 arch/alpha/boot/Makefile                  |    2 --
 arch/alpha/boot/misc.c                    |    2 +-
 arch/arm/boot/compressed/Makefile         |    2 +-
 arch/arm/boot/compressed/misc.c           |    2 +-
 arch/cris/arch-v10/boot/compressed/misc.c |    2 +-
 arch/cris/arch-v32/boot/compressed/misc.c |    2 +-
 arch/h8300/boot/compressed/misc.c         |    2 +-
 arch/m32r/boot/compressed/misc.c          |    2 +-
 arch/sh/boot/compressed/misc.c            |    2 +-
 arch/sh64/boot/compressed/misc.c          |    2 +-
 arch/x86/boot/compressed/misc_32.c        |    2 +-
 arch/x86/boot/compressed/misc_64.c        |    2 +-
 {lib => include/lib}/inflate.c            |    0 
 init/do_mounts_rd.c                       |    2 +-
 init/initramfs.c                          |    2 +-
 15 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/alpha/boot/Makefile b/arch/alpha/boot/Makefile
index cd14388..c53169c 100644
--- a/arch/alpha/boot/Makefile
+++ b/arch/alpha/boot/Makefile
@@ -112,5 +112,3 @@ $(obj)/bootpheader: $(obj)/bootloader.lds $(OBJ_bootph) $(LIBS_Y) FORCE
 
 $(obj)/bootpzheader: $(obj)/bootloader.lds $(OBJ_bootpzh) $(LIBS_Y) FORCE
 	$(call if_changed,ld)
-
-$(obj)/misc.o: lib/inflate.c
diff --git a/arch/alpha/boot/misc.c b/arch/alpha/boot/misc.c
index c00646b..c132505 100644
--- a/arch/alpha/boot/misc.c
+++ b/arch/alpha/boot/misc.c
@@ -100,7 +100,7 @@ static ulg free_mem_ptr_end;
 
 #define HEAP_SIZE 0x3000
 
-#include "../../../lib/inflate.c"
+#include <lib/inflate.c>
 
 static void *malloc(int size)
 {
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 5fde99f..563cfc2 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -111,5 +111,5 @@ $(obj)/font.c: $(FONTC)
 $(obj)/vmlinux.lds: $(obj)/vmlinux.lds.in arch/arm/boot/Makefile .config
 	@sed "$(SEDFLAGS)" < $< > $@
 
-$(obj)/misc.o: $(obj)/misc.c include/asm/arch/uncompress.h lib/inflate.c
+$(obj)/misc.o: $(obj)/misc.c include/asm/arch/uncompress.h
 
diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index 9b44402..7c3850d 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -241,7 +241,7 @@ static ulg free_mem_ptr_end;
 
 #define HEAP_SIZE 0x3000
 
-#include "../../../../lib/inflate.c"
+#include <lib/inflate.c>
 
 #ifndef STANDALONE_DEBUG
 static void *malloc(int size)
diff --git a/arch/cris/arch-v10/boot/compressed/misc.c b/arch/cris/arch-v10/boot/compressed/misc.c
index e205d2e..3298a66 100644
--- a/arch/cris/arch-v10/boot/compressed/misc.c
+++ b/arch/cris/arch-v10/boot/compressed/misc.c
@@ -108,7 +108,7 @@ static void puts(const char *);
 extern int end;
 static long free_mem_ptr = (long)&end;
  
-#include "../../../../../lib/inflate.c"
+#include <lib/inflate.c>
 
 static void *malloc(int size)
 {
diff --git a/arch/cris/arch-v32/boot/compressed/misc.c b/arch/cris/arch-v32/boot/compressed/misc.c
index 0169ba1..dc5a119 100644
--- a/arch/cris/arch-v32/boot/compressed/misc.c
+++ b/arch/cris/arch-v32/boot/compressed/misc.c
@@ -110,7 +110,7 @@ static void puts(const char *);
 extern int _end;
 static long free_mem_ptr = (long)&_end;
 
-#include "../../../../../lib/inflate.c"
+#include <lib/inflate.c>
 
 static void *malloc(int size)
 {
diff --git a/arch/h8300/boot/compressed/misc.c b/arch/h8300/boot/compressed/misc.c
index 8450745..863d794 100644
--- a/arch/h8300/boot/compressed/misc.c
+++ b/arch/h8300/boot/compressed/misc.c
@@ -92,7 +92,7 @@ static unsigned long free_mem_end_ptr;
 
 #define HEAP_SIZE             0x10000
 
-#include "../../../../lib/inflate.c"
+#include <lib/inflate.c>
 
 #define SCR *((volatile unsigned char *)0xffff8a)
 #define TDR *((volatile unsigned char *)0xffff8b)
diff --git a/arch/m32r/boot/compressed/misc.c b/arch/m32r/boot/compressed/misc.c
index 600d40e..dac3a0b 100644
--- a/arch/m32r/boot/compressed/misc.c
+++ b/arch/m32r/boot/compressed/misc.c
@@ -90,7 +90,7 @@ static unsigned long free_mem_end_ptr;
 
 #define HEAP_SIZE             0x10000
 
-#include "../../../../lib/inflate.c"
+#include <lib/inflate.c>
 
 static void *malloc(int size)
 {
diff --git a/arch/sh/boot/compressed/misc.c b/arch/sh/boot/compressed/misc.c
index df65e30..a00dd7e 100644
--- a/arch/sh/boot/compressed/misc.c
+++ b/arch/sh/boot/compressed/misc.c
@@ -99,7 +99,7 @@ static unsigned long free_mem_end_ptr;
 
 #define HEAP_SIZE             0x10000
 
-#include "../../../../lib/inflate.c"
+#include <lib/inflate.c>
 
 static void *malloc(int size)
 {
diff --git a/arch/sh64/boot/compressed/misc.c b/arch/sh64/boot/compressed/misc.c
index aea00c5..3b151f4 100644
--- a/arch/sh64/boot/compressed/misc.c
+++ b/arch/sh64/boot/compressed/misc.c
@@ -97,7 +97,7 @@ static unsigned long free_mem_end_ptr;
 
 #define HEAP_SIZE             0x10000
 
-#include "../../../../lib/inflate.c"
+#include <lib/inflate.c>
 
 static void *malloc(int size)
 {
diff --git a/arch/x86/boot/compressed/misc_32.c b/arch/x86/boot/compressed/misc_32.c
index b74d60d..fd8674e 100644
--- a/arch/x86/boot/compressed/misc_32.c
+++ b/arch/x86/boot/compressed/misc_32.c
@@ -199,7 +199,7 @@ static int lines, cols;
 void *xquad_portio;
 #endif
 
-#include "../../../../lib/inflate.c"
+#include <lib/inflate.c>
 
 static void *malloc(int size)
 {
diff --git a/arch/x86/boot/compressed/misc_64.c b/arch/x86/boot/compressed/misc_64.c
index 6ea015a..315e667 100644
--- a/arch/x86/boot/compressed/misc_64.c
+++ b/arch/x86/boot/compressed/misc_64.c
@@ -195,7 +195,7 @@ static char *vidmem = (char *)0xb8000;
 static int vidport;
 static int lines, cols;
 
-#include "../../../../lib/inflate.c"
+#include <lib/inflate.c>
 
 static void *malloc(int size)
 {
diff --git a/lib/inflate.c b/include/lib/inflate.c
similarity index 100%
rename from lib/inflate.c
rename to include/lib/inflate.c
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 3ac5904..cf364f6 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -319,7 +319,7 @@ static void __init error(char *m);
 static void __init gzip_mark(void **);
 static void __init gzip_release(void **);
 
-#include "../lib/inflate.c"
+#include <lib/inflate.c>
 
 static void __init *malloc(size_t size)
 {
diff --git a/init/initramfs.c b/init/initramfs.c
index 1db02a0..23c588b 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -410,7 +410,7 @@ static void __init error(char *m);
 static void __init gzip_mark(void **);
 static void __init gzip_release(void **);
 
-#include "../lib/inflate.c"
+#include <lib/inflate.c>
 
 static void __init gzip_mark(void **ptr)
 {



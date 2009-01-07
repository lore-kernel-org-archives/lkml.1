Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZAGIeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZAGIeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 03:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZAGIeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 03:34:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53950 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZAGIeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 03:34:10 -0500
Message-ID: <496468EE.9000802@zytor.com>
Date: Wed, 07 Jan 2009 00:33:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>, Sam Ravnborg <sam@ravnborg.org>,
       the arch/x86 maintainers <x86@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Patches applied to tip:x86/setup-lzma
References: <200901042146.n04LkGTC005829@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu>
In-Reply-To: <200901042146.n04LkGTC005829@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu>
Content-Type: multipart/mixed;
 boundary="------------080909020803090001040706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080909020803090001040706
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

I just applied these three patches to the tip:x86/setup-lzma tree to
resolve the build issues in some configurations.  The third and largest
patch is a slightly modified version of Alain's last patch, the other
two addresses the Kconfig chain.  Please review.

	-hpa


--------------080909020803090001040706
Content-Type: text/x-patch;
 name="0001-bzip2-lzma-DECOMPRESS_GZIP-should-select-ZLIB_INFLA.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-bzip2-lzma-DECOMPRESS_GZIP-should-select-ZLIB_INFLA.pat";
 filename*1="ch"

>From 7856a16ea03ed9b17860d756ee6473c2e57882b2 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Wed, 7 Jan 2009 00:01:43 -0800
Subject: [PATCH] bzip2/lzma: DECOMPRESS_GZIP should select ZLIB_INFLATE

Impact: Partial resolution of build failure

DECOMPRESS_GZIP is just a common-interface wrapper around the
zlib_inflate code; it thus need to select it.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 lib/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index e37f061..daa4818 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -102,6 +102,7 @@ config LZO_DECOMPRESS
 # ZLIB_INFLATE; DECOMPRESS_GZIP is just a wrapper.)
 #
 config DECOMPRESS_GZIP
+	select ZLIB_INFLATE
 	tristate
 
 config DECOMPRESS_BZIP2
-- 
1.5.6.6


--------------080909020803090001040706
Content-Type: text/x-patch;
 name="0002-bzip2-lzma-move-initrd-ramfs-options-out-of-BLK_DEV.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-bzip2-lzma-move-initrd-ramfs-options-out-of-BLK_DEV.pat";
 filename*1="ch"

>From fb9a4ca9820fd4d7c4906bd393004662451e273e Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Wed, 7 Jan 2009 00:03:49 -0800
Subject: [PATCH] bzip2/lzma: move initrd/ramfs options out of BLK_DEV

Impact: Partial resolution of build failure

Move the initrd/initramfs configuration options from
drivers/block/Kconfig to usr/Kconfig, since they do not and should not
depend on CONFIG_BLK_DEV.  This fixes builds when CONFIG_BLK_DEV=n.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 drivers/block/Kconfig |   27 ---------------------------
 usr/Kconfig           |   27 +++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index cc9fa69..0344a8a 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -358,33 +358,6 @@ config BLK_DEV_XIP
 	  will prevent RAM block device backing store memory from being
 	  allocated from highmem (only a problem for highmem systems).
 
-config RD_GZIP
-	bool "Initial ramdisk compressed using gzip"
-	default y
-	depends on BLK_DEV_INITRD=y
-	select DECOMPRESS_GZIP
-	help
-	  Support loading of a gzip encoded initial ramdisk or cpio buffer.
-	  If unsure, say Y.
-
-config RD_BZIP2
-	bool "Initial ramdisk compressed using bzip2"
-	default n
-	depends on BLK_DEV_INITRD=y
-	select DECOMPRESS_BZIP2
-	help
-	  Support loading of a bzip2 encoded initial ramdisk or cpio buffer
-	  If unsure, say N.
-
-config RD_LZMA
-	bool "Initial ramdisk compressed using lzma"
-	default n
-	depends on BLK_DEV_INITRD=y
-	select DECOMPRESS_LZMA
-	help
-	  Support loading of a lzma encoded initial ramdisk or cpio buffer
-	  If unsure, say N.
-
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
diff --git a/usr/Kconfig b/usr/Kconfig
index 86cecb5..a691a8f 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -44,3 +44,30 @@ config INITRAMFS_ROOT_GID
 	  owned by group root in the initial ramdisk image.
 
 	  If you are not sure, leave it set to "0".
+
+config RD_GZIP
+	bool "Initial ramdisk compressed using gzip"
+	default y
+	depends on BLK_DEV_INITRD=y
+	select DECOMPRESS_GZIP
+	help
+	  Support loading of a gzip encoded initial ramdisk or cpio buffer.
+	  If unsure, say Y.
+
+config RD_BZIP2
+	bool "Initial ramdisk compressed using bzip2"
+	default n
+	depends on BLK_DEV_INITRD=y
+	select DECOMPRESS_BZIP2
+	help
+	  Support loading of a bzip2 encoded initial ramdisk or cpio buffer
+	  If unsure, say N.
+
+config RD_LZMA
+	bool "Initial ramdisk compressed using lzma"
+	default n
+	depends on BLK_DEV_INITRD=y
+	select DECOMPRESS_LZMA
+	help
+	  Support loading of a lzma encoded initial ramdisk or cpio buffer
+	  If unsure, say N.
-- 
1.5.6.6


--------------080909020803090001040706
Content-Type: text/x-patch;
 name="0003-bzip2-lzma-fix-built-in-initramfs-vs-CONFIG_RD_GZIP.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0003-bzip2-lzma-fix-built-in-initramfs-vs-CONFIG_RD_GZIP.pat";
 filename*1="ch"

>From a26ee60f90daffe1de6be0d093af86e7279b3dfd Mon Sep 17 00:00:00 2001
From: Alain Knaff <alain@knaff.lu>
Date: Wed, 7 Jan 2009 00:10:27 -0800
Subject: [PATCH] bzip2/lzma: fix built-in initramfs vs CONFIG_RD_GZIP

Impact: Resolves build failures in some configurations

Makes it possible to disable CONFIG_RD_GZIP . In that case, the
built-in initramfs will be compressed by whatever compressor is
available (bzip2 or lzma) or left uncompressed if none is available.

It also removes a couple of warnings which occur when no ramdisk
compression at all is chosen.

It also restores the select ZLIB_INFLATE in drivers/block/Kconfig
which somehow came missing. This is needed to activate compilation of
the stuff in zlib_deflate.

Signed-off-by: Alain Knaff <alain@knaff.lu>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 init/initramfs.c              |    7 +++++-
 scripts/gen_initramfs_list.sh |   17 ++++++++++-----
 usr/Makefile                  |   42 +++++++++++++++++++++++++++++-----------
 usr/initramfs_data.S          |    2 +-
 usr/initramfs_data.bz2.S      |   29 ++++++++++++++++++++++++++++
 usr/initramfs_data.gz.S       |   29 ++++++++++++++++++++++++++++
 usr/initramfs_data.lzma.S     |   29 ++++++++++++++++++++++++++++
 7 files changed, 135 insertions(+), 20 deletions(-)
 create mode 100644 usr/initramfs_data.bz2.S
 create mode 100644 usr/initramfs_data.gz.S
 create mode 100644 usr/initramfs_data.lzma.S

diff --git a/init/initramfs.c b/init/initramfs.c
index 40bd4fb..a3ba91c 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -389,7 +389,7 @@ static int __init write_buffer(char *buf, unsigned len)
 	return len - count;
 }
 
-
+#if defined CONFIG_RD_GZIP || defined CONFIG_RD_BZIP2 || defined CONFIG_RD_LZMA
 static int __init flush_buffer(void *bufv, unsigned len)
 {
 	char *buf = (char *) bufv;
@@ -412,6 +412,7 @@ static int __init flush_buffer(void *bufv, unsigned len)
 	}
 	return origLen;
 }
+#endif
 
 static unsigned my_inptr;   /* index of next byte to be processed in inbuf */
 
@@ -449,10 +450,12 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
 			continue;
 		}
 		this_header = 0;
+#ifdef CONFIG_RD_GZIP
 		if (!gunzip(buf, len, NULL, flush_buffer, NULL,
 			    &my_inptr, error) &&
 		    message == NULL)
 			goto ok;
+#endif
 
 #ifdef CONFIG_RD_BZIP2
 		message = NULL; /* Zero out message, or else cpio will
@@ -473,7 +476,9 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
 			goto ok;
 		}
 #endif
+#if defined CONFIG_RD_GZIP || defined CONFIG_RD_BZIP2 || defined CONFIG_RD_LZMA
 ok:
+#endif
 		if (state != Reset)
 			error("junk in compressed archive");
 		this_header = saved_offset + my_inptr;
diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 5f3415f..41041e4 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -5,7 +5,7 @@
 # Released under the terms of the GNU GPL
 #
 # Generate a cpio packed initramfs. It uses gen_init_cpio to generate
-# the cpio archive, and gzip to pack it.
+# the cpio archive, and then compresses it.
 # The script may also be used to generate the inputfile used for gen_init_cpio
 # This script assumes that gen_init_cpio is located in usr/ directory
 
@@ -16,8 +16,8 @@ usage() {
 cat << EOF
 Usage:
 $0 [-o <file>] [-u <uid>] [-g <gid>] {-d | <cpio_source>} ...
-	-o <file>      Create gzipped initramfs file named <file> using
-		       gen_init_cpio and gzip
+	-o <file>      Create compressed initramfs file named <file> using
+		       gen_init_cpio and compressor depending on the extension
 	-u <uid>       User ID to map to user ID 0 (root).
 		       <uid> is only meaningful if <cpio_source> is a
 		       directory.  "squash" forces all files to uid 0.
@@ -225,6 +225,7 @@ cpio_list=
 output="/dev/stdout"
 output_file=""
 is_cpio_compressed=
+compr="gzip -9 -f"
 
 arg="$1"
 case "$arg" in
@@ -233,11 +234,15 @@ case "$arg" in
 		echo "deps_initramfs := \\"
 		shift
 		;;
-	"-o")	# generate gzipped cpio image named $1
+	"-o")	# generate compressed cpio image named $1
 		shift
 		output_file="$1"
 		cpio_list="$(mktemp ${TMPDIR:-/tmp}/cpiolist.XXXXXX)"
 		output=${cpio_list}
+		echo "$output_file" | grep -q "\.gz$" && compr="gzip -9 -f"
+		echo "$output_file" | grep -q "\.bz2$" && compr="bzip2 -9 -f"
+		echo "$output_file" | grep -q "\.lzma$" && compr="lzma -9 -f"
+		echo "$output_file" | grep -q "\.cpio$" && compr="cat"
 		shift
 		;;
 esac
@@ -274,7 +279,7 @@ while [ $# -gt 0 ]; do
 	esac
 done
 
-# If output_file is set we will generate cpio archive and gzip it
+# If output_file is set we will generate cpio archive and compress it
 # we are carefull to delete tmp files
 if [ ! -z ${output_file} ]; then
 	if [ -z ${cpio_file} ]; then
@@ -287,7 +292,7 @@ if [ ! -z ${output_file} ]; then
 	if [ "${is_cpio_compressed}" = "compressed" ]; then
 		cat ${cpio_tfile} > ${output_file}
 	else
-		cat ${cpio_tfile} | gzip -f -9 - > ${output_file}
+		cat ${cpio_tfile} | ${compr}  - > ${output_file}
 	fi
 	[ -z ${cpio_file} ] && rm ${cpio_tfile}
 fi
diff --git a/usr/Makefile b/usr/Makefile
index 201f27f..451cdff 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -5,14 +5,32 @@
 klibcdirs:;
 PHONY += klibcdirs
 
+# Find out "preferred" ramdisk compressor. Order of preference is
+#  1. bzip2 efficient, and likely to be present
+#  2. gzip former default
+#  3. lzma
+#  4. none
+
+# None of the above
+suffix_y                   =
+
+# Lzma, but no gzip nor bzip2
+suffix_$(CONFIG_RD_LZMA)   = .lzma
+
+# Gzip, but no bzip2
+suffix_$(CONFIG_RD_GZIP)   = .gz
+
+# Bzip2
+suffix_$(CONFIG_RD_BZIP2)  = .bz2
+
 
 # Generate builtin.o based on initramfs_data.o
-obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o
+obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data$(suffix_y).o
 
-# initramfs_data.o contains the initramfs_data.cpio.gz image.
+# initramfs_data.o contains the compressed initramfs_data.cpio image.
 # The image is included using .incbin, a dependency which is not
 # tracked automatically.
-$(obj)/initramfs_data.o: $(obj)/initramfs_data.cpio.gz FORCE
+$(obj)/initramfs_data$(suffix_y).o: $(obj)/initramfs_data.cpio$(suffix_y) FORCE
 
 #####
 # Generate the initramfs cpio archive
@@ -25,28 +43,28 @@ ramfs-args  := \
         $(if $(CONFIG_INITRAMFS_ROOT_UID), -u $(CONFIG_INITRAMFS_ROOT_UID)) \
         $(if $(CONFIG_INITRAMFS_ROOT_GID), -g $(CONFIG_INITRAMFS_ROOT_GID))
 
-# .initramfs_data.cpio.gz.d is used to identify all files included
+# .initramfs_data.cpio.d is used to identify all files included
 # in initramfs and to detect if any files are added/removed.
 # Removed files are identified by directory timestamp being updated
 # The dependency list is generated by gen_initramfs.sh -l
-ifneq ($(wildcard $(obj)/.initramfs_data.cpio.gz.d),)
-	include $(obj)/.initramfs_data.cpio.gz.d
+ifneq ($(wildcard $(obj)/.initramfs_data.cpio.d),)
+	include $(obj)/.initramfs_data.cpio.d
 endif
 
 quiet_cmd_initfs = GEN     $@
       cmd_initfs = $(initramfs) -o $@ $(ramfs-args) $(ramfs-input)
 
-targets := initramfs_data.cpio.gz
+targets := initramfs_data.cpio.gz initramfs_data.cpio.bz2 initramfs_data.cpio.lzma initramfs_data.cpio
 # do not try to update files included in initramfs
 $(deps_initramfs): ;
 
 $(deps_initramfs): klibcdirs
-# We rebuild initramfs_data.cpio.gz if:
-# 1) Any included file is newer then initramfs_data.cpio.gz
+# We rebuild initramfs_data.cpio if:
+# 1) Any included file is newer then initramfs_data.cpio
 # 2) There are changes in which files are included (added or deleted)
-# 3) If gen_init_cpio are newer than initramfs_data.cpio.gz
+# 3) If gen_init_cpio are newer than initramfs_data.cpio
 # 4) arguments to gen_initramfs.sh changes
-$(obj)/initramfs_data.cpio.gz: $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
-	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/.initramfs_data.cpio.gz.d
+$(obj)/initramfs_data.cpio$(suffix_y): $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
+	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/.initramfs_data.cpio.d
 	$(call if_changed,initfs)
 
diff --git a/usr/initramfs_data.S b/usr/initramfs_data.S
index c2e1ad4..7c6973d 100644
--- a/usr/initramfs_data.S
+++ b/usr/initramfs_data.S
@@ -26,5 +26,5 @@ SECTIONS
 */
 
 .section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio.gz"
+.incbin "usr/initramfs_data.cpio"
 
diff --git a/usr/initramfs_data.bz2.S b/usr/initramfs_data.bz2.S
new file mode 100644
index 0000000..bc54d09
--- /dev/null
+++ b/usr/initramfs_data.bz2.S
@@ -0,0 +1,29 @@
+/*
+  initramfs_data includes the compressed binary that is the
+  filesystem used for early user space.
+  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
+  released on 2001-07-14) dit not support .incbin.
+  If you are forced to use older binutils than that then the
+  following trick can be applied to create the resulting binary:
+
+
+  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
+  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
+   ld -m elf_i386  -r -o built-in.o initramfs_data.o
+
+  initramfs_data.scr looks like this:
+SECTIONS
+{
+       .init.ramfs : { *(.data) }
+}
+
+  The above example is for i386 - the parameters vary from architectures.
+  Eventually look up LDFLAGS_BLOB in an older version of the
+  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
+
+  Using .incbin has the advantage over ld that the correct flags are set
+  in the ELF header, as required by certain architectures.
+*/
+
+.section .init.ramfs,"a"
+.incbin "usr/initramfs_data.cpio.bz2"
diff --git a/usr/initramfs_data.gz.S b/usr/initramfs_data.gz.S
new file mode 100644
index 0000000..890c8dd
--- /dev/null
+++ b/usr/initramfs_data.gz.S
@@ -0,0 +1,29 @@
+/*
+  initramfs_data includes the compressed binary that is the
+  filesystem used for early user space.
+  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
+  released on 2001-07-14) dit not support .incbin.
+  If you are forced to use older binutils than that then the
+  following trick can be applied to create the resulting binary:
+
+
+  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
+  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
+   ld -m elf_i386  -r -o built-in.o initramfs_data.o
+
+  initramfs_data.scr looks like this:
+SECTIONS
+{
+       .init.ramfs : { *(.data) }
+}
+
+  The above example is for i386 - the parameters vary from architectures.
+  Eventually look up LDFLAGS_BLOB in an older version of the
+  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
+
+  Using .incbin has the advantage over ld that the correct flags are set
+  in the ELF header, as required by certain architectures.
+*/
+
+.section .init.ramfs,"a"
+.incbin "usr/initramfs_data.cpio.gz"
diff --git a/usr/initramfs_data.lzma.S b/usr/initramfs_data.lzma.S
new file mode 100644
index 0000000..e11469e
--- /dev/null
+++ b/usr/initramfs_data.lzma.S
@@ -0,0 +1,29 @@
+/*
+  initramfs_data includes the compressed binary that is the
+  filesystem used for early user space.
+  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
+  released on 2001-07-14) dit not support .incbin.
+  If you are forced to use older binutils than that then the
+  following trick can be applied to create the resulting binary:
+
+
+  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
+  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
+   ld -m elf_i386  -r -o built-in.o initramfs_data.o
+
+  initramfs_data.scr looks like this:
+SECTIONS
+{
+       .init.ramfs : { *(.data) }
+}
+
+  The above example is for i386 - the parameters vary from architectures.
+  Eventually look up LDFLAGS_BLOB in an older version of the
+  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
+
+  Using .incbin has the advantage over ld that the correct flags are set
+  in the ELF header, as required by certain architectures.
+*/
+
+.section .init.ramfs,"a"
+.incbin "usr/initramfs_data.cpio.lzma"
-- 
1.5.6.6


--------------080909020803090001040706--

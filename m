Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbYGOMTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbYGOMTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758385AbYGOMNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:13:34 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39585 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758263AbYGOMNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:13:32 -0400
Date: Tue, 15 Jul 2008 15:13:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com, "H.J. Lu" <hjl.tools@gmail.com>, sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: binutils 2.18.50.0.8 frv build error
Message-ID: <20080715121327.GA24533@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toolchain:
- gcc 4.3.1
- binutils 2.18.50.0.7 and 2.18.50.0.8
- configured for frv-linux
- kernel 2.6.26

Builds fine when using binutils 2.18.50.0.7,
but fails as follows with binutils 2.18.50.0.8:

<--  snip  -->

...
  HOSTCC  scripts/kallsyms
  CC      init/main.o
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  CC      init/do_mounts.o
  LD      init/mounts.o
  CC      init/noinitramfs.o
  LD      init/built-in.o
frv-linux-ld: init/mounts.o: compiled with -fpic and linked with modules that use non-pic relocations
frv-linux-ld: failed to merge target specific data of file init/mounts.o
make[2]: *** [init/built-in.o] Error 1

<--  snip  -->

Complete verbose log below.

Any hints what's going wrong?

cu
Adrian


make -f /tmp/linux-2.6.26/Makefile silentoldconfig
make -f scripts/Makefile.build obj=scripts/basic
mkdir -p include/linux include/config
make -f scripts/Makefile.build obj=scripts/kconfig silentoldconfig
scripts/kconfig/conf -s arch/frv/Kconfig
rm -f include/config/kernel.release
echo 2.6.26 > include/config/kernel.release
set -e; :; mkdir -p include/linux/; 	(echo \#define LINUX_VERSION_CODE 132634; echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < /tmp/linux-2.6.26/Makefile > include/linux/version.h.tmp; if [ -r include/linux/version.h ] && cmp -s include/linux/version.h include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; else :; mv -f include/linux/version.h.tmp include/linux/version.h; fi
set -e; :; mkdir -p include/linux/; 	if [ `echo -n "2.6.26" | wc -c ` -gt 64 ]; then echo '"2.6.26" exceeds 64 characters' >&2; exit 1; fi; (echo \#define UTS_RELEASE \"2.6.26\";) < include/config/kernel.release > include/linux/utsrelease.h.tmp; if [ -r include/linux/utsrelease.h ] && cmp -s include/linux/utsrelease.h include/linux/utsrelease.h.tmp; then rm -f include/linux/utsrelease.h.tmp; else :; mv -f include/linux/utsrelease.h.tmp include/linux/utsrelease.h; fi
set -e; asmlink=`readlink include/asm | cut -d '-' -f 2`;   \
	if [ -L include/asm ]; then                                     \
		if [ "$asmlink" != "frv" ]; then                \
			echo "ERROR: the symlink include/asm points to asm-$asmlink but asm-frv was expected"; \
			echo "       set ARCH or save .config and run 'make mrproper' to fix it";             \
			exit 1;                                         \
		fi;                                                     \
	else                                                            \
		echo '  SYMLINK include/asm -> include/asm-frv';          \
		if [ ! -d include ]; then                               \
			mkdir -p include;                               \
		fi;                                                     \
		ln -fsn asm-frv include/asm;                              \
	fi
  SYMLINK include/asm -> include/asm-frv
mkdir -p .tmp_versions ; rm -f .tmp_versions/*
make -f scripts/Makefile.build obj=scripts/basic
(cat /dev/null; ) > scripts/basic/modules.order
make -f scripts/Makefile.build obj=.
(cat /dev/null; ) > modules.order
mkdir -p kernel/
  frv-linux-gcc -Wp,-MD,kernel/.bounds.s.d  -nostdinc -isystem /usr/local/DIR/gcc-frv-4.3.1/lib/gcc/frv-linux/4.3.1/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -O2   -fno-stack-protector -G4 -mno-linked-fp -mcpu=fr450 -mno-fdpic -mgpr-32 -msoft-float -mno-media -ffixed-fcc3 -ffixed-cc3 -ffixed-gr15 -ffixed-icc2 -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(bounds)"  -D"KBUILD_MODNAME=KBUILD_STR(bounds)" -fverbose-asm -S -o kernel/bounds.s kernel/bounds.c
mkdir -p include/linux/
  	(set -e; echo "#ifndef __LINUX_BOUNDS_H__"; echo "#define __LINUX_BOUNDS_H__"; echo "/*"; echo " * DO NOT MODIFY."; echo " *"; echo " * This file was generated by Kbuild"; echo " *"; echo " */"; echo ""; sed -ne 	"/^->/{s:->#\(.*\):/* \1 */:; s:^->\([^ ]*\) [\$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; s:->::; p;}" kernel/bounds.s; echo ""; echo "#endif" ) > include/linux/bounds.h
mkdir -p arch/frv/kernel/
  frv-linux-gcc -Wp,-MD,arch/frv/kernel/.asm-offsets.s.d  -nostdinc -isystem /usr/local/DIR/gcc-frv-4.3.1/lib/gcc/frv-linux/4.3.1/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -O2   -fno-stack-protector -G4 -mno-linked-fp -mcpu=fr450 -mno-fdpic -mgpr-32 -msoft-float -mno-media -ffixed-fcc3 -ffixed-cc3 -ffixed-gr15 -ffixed-icc2 -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(asm_offsets)"  -D"KBUILD_MODNAME=KBUILD_STR(asm_offsets)" -fverbose-asm -S -o arch/frv/kernel/asm-offsets.s arch/frv/kernel/asm-offsets.c
mkdir -p include/asm-frv/
  	(set -e; echo "#ifndef __ASM_OFFSETS_H__"; echo "#define __ASM_OFFSETS_H__"; echo "/*"; echo " * DO NOT MODIFY."; echo " *"; echo " * This file was generated by Kbuild"; echo " *"; echo " */"; echo ""; sed -ne 	"/^->/{s:->#\(.*\):/* \1 */:; s:^->\([^ ]*\) [\$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; s:->::; p;}" arch/frv/kernel/asm-offsets.s; echo ""; echo "#endif" ) > include/asm-frv/asm-offsets.h
make -f scripts/Makefile.build obj=. missing-syscalls
  /bin/sh scripts/checksyscalls.sh frv-linux-gcc -Wp,-MD,./.missing-syscalls.d  -nostdinc -isystem /usr/local/DIR/gcc-frv-4.3.1/lib/gcc/frv-linux/4.3.1/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -O2   -fno-stack-protector -G4 -mno-linked-fp -mcpu=fr450 -mno-fdpic -mgpr-32 -msoft-float -mno-media -ffixed-fcc3 -ffixed-cc3 -ffixed-gr15 -ffixed-icc2 -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(missing_syscalls)"  -D"KBUILD_MODNAME=KBUILD_STR(missing_syscalls)"
<stdin>:461:2: warning: #warning syscall mmap not implemented
make -f scripts/Makefile.build obj=scripts
make -f scripts/Makefile.build obj=scripts/mod
(cat /dev/null; ) > scripts/mod/modules.order
  frv-linux-gcc -Wp,-MD,scripts/mod/.empty.o.d  -nostdinc -isystem /usr/local/DIR/gcc-frv-4.3.1/lib/gcc/frv-linux/4.3.1/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -O2   -fno-stack-protector -G4 -mno-linked-fp -mcpu=fr450 -mno-fdpic -mgpr-32 -msoft-float -mno-media -ffixed-fcc3 -ffixed-cc3 -ffixed-gr15 -ffixed-icc2 -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(empty)"  -D"KBUILD_MODNAME=KBUILD_STR(empty)" -c -o scripts/mod/empty.o scripts/mod/empty.c
  gcc -Wp,-MD,scripts/mod/.mk_elfconfig.d -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer     -o scripts/mod/mk_elfconfig scripts/mod/mk_elfconfig.c  
  scripts/mod/mk_elfconfig frv < scripts/mod/empty.o > scripts/mod/elfconfig.h
  gcc -Wp,-MD,scripts/mod/.file2alias.o.d -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer     -c -o scripts/mod/file2alias.o scripts/mod/file2alias.c
  gcc -Wp,-MD,scripts/mod/.modpost.o.d -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer     -c -o scripts/mod/modpost.o scripts/mod/modpost.c
  gcc -Wp,-MD,scripts/mod/.sumversion.o.d -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer     -c -o scripts/mod/sumversion.o scripts/mod/sumversion.c
  gcc  -o scripts/mod/modpost scripts/mod/modpost.o scripts/mod/file2alias.o scripts/mod/sumversion.o  
(cat /dev/null; ) > scripts/modules.order
  gcc -Wp,-MD,scripts/.kallsyms.d -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer     -o scripts/kallsyms scripts/kallsyms.c  
make -f scripts/Makefile.build obj=init
  frv-linux-gcc -Wp,-MD,init/.main.o.d  -nostdinc -isystem /usr/local/DIR/gcc-frv-4.3.1/lib/gcc/frv-linux/4.3.1/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -O2   -fno-stack-protector -G4 -mno-linked-fp -mcpu=fr450 -mno-fdpic -mgpr-32 -msoft-float -mno-media -ffixed-fcc3 -ffixed-cc3 -ffixed-gr15 -ffixed-icc2 -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(main)"  -D"KBUILD_MODNAME=KBUILD_STR(main)" -c -o init/main.o init/main.c
/bin/sh /tmp/linux-2.6.26/scripts/mkcompile_h include/linux/compile.h \
	"frv" "" "" "frv-linux-gcc -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -O2   -fno-stack-protector -G4 -mno-linked-fp -mcpu=fr450 -mno-fdpic -mgpr-32 -msoft-float -mno-media -ffixed-fcc3 -ffixed-cc3 -ffixed-gr15 -ffixed-icc2 -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign"
  UPD     include/linux/compile.h
  frv-linux-gcc -Wp,-MD,init/.version.o.d  -nostdinc -isystem /usr/local/DIR/gcc-frv-4.3.1/lib/gcc/frv-linux/4.3.1/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -O2   -fno-stack-protector -G4 -mno-linked-fp -mcpu=fr450 -mno-fdpic -mgpr-32 -msoft-float -mno-media -ffixed-fcc3 -ffixed-cc3 -ffixed-gr15 -ffixed-icc2 -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(version)"  -D"KBUILD_MODNAME=KBUILD_STR(version)" -c -o init/version.o init/version.c
  frv-linux-gcc -Wp,-MD,init/.do_mounts.o.d  -nostdinc -isystem /usr/local/DIR/gcc-frv-4.3.1/lib/gcc/frv-linux/4.3.1/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -O2   -fno-stack-protector -G4 -mno-linked-fp -mcpu=fr450 -mno-fdpic -mgpr-32 -msoft-float -mno-media -ffixed-fcc3 -ffixed-cc3 -ffixed-gr15 -ffixed-icc2 -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(do_mounts)"  -D"KBUILD_MODNAME=KBUILD_STR(mounts)" -c -o init/do_mounts.o init/do_mounts.c
  frv-linux-ld    -r -o init/mounts.o init/do_mounts.o 
  frv-linux-gcc -Wp,-MD,init/.noinitramfs.o.d  -nostdinc -isystem /usr/local/DIR/gcc-frv-4.3.1/lib/gcc/frv-linux/4.3.1/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -O2   -fno-stack-protector -G4 -mno-linked-fp -mcpu=fr450 -mno-fdpic -mgpr-32 -msoft-float -mno-media -ffixed-fcc3 -ffixed-cc3 -ffixed-gr15 -ffixed-icc2 -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(noinitramfs)"  -D"KBUILD_MODNAME=KBUILD_STR(noinitramfs)" -c -o init/noinitramfs.o init/noinitramfs.c
   frv-linux-ld    -r -o init/built-in.o init/main.o init/version.o init/mounts.o init/noinitramfs.o 
frv-linux-ld: init/mounts.o: compiled with -fpic and linked with modules that use non-pic relocations
frv-linux-ld: failed to merge target specific data of file init/mounts.o
make[1]: *** [init/built-in.o] Error 1
make: *** [init] Error 2

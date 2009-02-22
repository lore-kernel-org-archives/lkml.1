Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbZBVW2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbZBVW2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZBVW15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:27:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:26510 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbZBVW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:27:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WIYphV7KVWySdFJ3F1ES587DhdJavomnf8qbV++HLiJ/o+LwpyPnU7toJJKd1xje92
         9MW0a9Lr2xgBFs7JRpz4+TyAvL7oUmueySP65f4TQIpSbaLCKKCAhDeYdkhTAvmmM2ab
         j2ytl4hWoaF1Oi6FmbuSHAnIulrCmpBjyx9HA=
Message-ID: <49A1D167.8050801@gmail.com>
Date: Sun, 22 Feb 2009 23:27:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel building procedure changed?
References: <20090222220747.GB7279@localhost> <20090222221653.GA30498@uranus.ravnborg.org>
In-Reply-To: <20090222221653.GA30498@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.2.2009 23:16, Sam Ravnborg wrote:
> On Mon, Feb 23, 2009 at 01:07:48AM +0300, Cyrill Gorcunov wrote:
>> Hi all,
>>
>> I found a bit strange thing happens now --
>> plain
>>
>> 	make arch/x86/kernel/head64.o
>>
>> doesn't work anymore. Instead of compiling
>> _just_ this file I've got the following:
>>
>> ---
>> cyrill@lenovo linux-2.6.git $ make arch/x86/kernel/head64.o
>>    CHK     include/linux/version.h
>>    CHK     include/linux/utsrelease.h
>>    SYMLINK include/asm ->  include/asm-x86
>>    CALL    scripts/checksyscalls.sh
>>    CHK     include/linux/compile.h
>>    AS      arch/x86/kernel/head_64.o
>>    VDSOSYM arch/x86/vdso/vdso-syms.lds
>>    VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
>>    VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
>>    VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
>>    VDSOSYM arch/x86/vdso/vdso32-syms.lds
>>    LD      arch/x86/vdso/built-in.o
>>    CC      fs/hpfs/dnode.o
>> make[2]: *** [fs/hpfs/dnode.o] Interrupt
>> make[1]: *** [fs/hpfs] Interrupt
>> make: *** [fs] Interrupt
>> ---
>>
>> I've done make allyesconfig previously.
>> I don't understand what I'm doing wrong... :(
>
> I should work...

It is matter of days, new mmotm doesn't work either, older did.

> Do you have CONFIG_64BIT set in your config?

Me yes.

> Does it behave strange also for files in kernel/?

No, only some of arch/x86/kernel/something.o.
arch/x86/kernel/ itself is OK.

Doesn't work:
arch/x86/kernel/head64.o
arch/x86/kernel/head_64.o
Works:
arch/x86/kernel/module_64.o
arch/x86/kernel/msr.o
arch/x86/kernel/rtc.o

> Can you postthe output of a "make V=1 arch/x86/kernel/head64.o"

$ make O=../bu/ arch/x86/kernel/head64.o
make -C /home/l/latest/bu \
         KBUILD_SRC=/home/l/latest/xxx \
         KBUILD_EXTMOD="" -f /home/l/latest/xxx/Makefile \
         arch/x86/kernel/head64.o
rm -f include/config/kernel.release
echo 2.6.29-rc5-mm1-g67514f8 > include/config/kernel.release
if [ -f /home/l/latest/xxx/.config -o -d 
/home/l/latest/xxx/include/config ]; then \
                 echo "  /home/l/latest/xxx is not clean, please run 
'make mrproper'";\
                 echo "  in the '/home/l/latest/xxx' directory.";\
                 /bin/false; \
         fi;
if [ ! -d include2 ]; then                                  \
             mkdir -p include2;                                          \
             ln -fsn /home/l/latest/xxx/include/asm-x86 include2/asm;     \
         fi
ln -fsn /home/l/latest/xxx source
/bin/sh /home/l/latest/xxx/scripts/mkmakefile \
             /home/l/latest/xxx /home/l/latest/bu 2 6
   GEN     /home/l/latest/bu/Makefile
set -e; : '  CHK     include/linux/version.h'; mkdir -p include/linux/; 
         (echo \#define LINUX_VERSION_CODE 132637; echo '#define 
KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < 
/home/l/latest/xxx/Makefile > include/linux/version.h.tmp; if [ -r 
include/linux/version.h ] && cmp -s include/linux/version.h 
include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; 
else : '  UPD     include/linux/version.h'; mv -f 
include/linux/version.h.tmp include/linux/version.h; fi
set -e; : '  CHK     include/linux/utsrelease.h'; mkdir -p 
include/linux/;      if [ `echo -n "2.6.29-rc5-mm1-g67514f8" | wc -c ` 
-gt 64 ]; then echo '"2.6.29-rc5-mm1-g67514f8" exceeds 64 characters' 
 >&2; exit 1; fi; (echo \#define UTS_RELEASE 
\"2.6.29-rc5-mm1-g67514f8\";) < include/config/kernel.release > 
include/linux/utsrelease.h.tmp; if [ -r include/linux/utsrelease.h ] && 
cmp -s include/linux/utsrelease.h include/linux/utsrelease.h.tmp; then 
rm -f include/linux/utsrelease.h.tmp; else : '  UPD 
include/linux/utsrelease.h'; mv -f include/linux/utsrelease.h.tmp 
include/linux/utsrelease.h; fi
set -e; if [ -L include/asm ]; then asmlink=`readlink include/asm | cut 
-d '-' -f 2`; if [ "$asmlink" != "x86" ]; then echo "ERROR: the symlink 
include/asm points to asm-$asmlink but asm-x86 was expected"; echo " 
    set ARCH or save .config and run 'make mrproper' to fix it"; exit 1; 
fi; test -e $asmlink || rm include/asm; elif [ -d include/asm ]; then 
echo "ERROR: include/asm is a directory but a symlink was expected"; 
exit 1; fi
if [ ! -L include/asm ]; then : '  SYMLINK include/asm -> 
include/asm-x86'; if [ ! -d include/asm-x86 ]; then mkdir -p 
include/asm-x86; fi; ln -fsn asm-x86 include/asm; fi
mkdir -p .tmp_versions
make -f /home/l/latest/xxx/scripts/Makefile.build obj=scripts/basic
make -f /home/l/latest/xxx/scripts/Makefile.build obj=.
mkdir -p kernel/
mkdir -p arch/x86/kernel/
make -f /home/l/latest/xxx/scripts/Makefile.build obj=. missing-syscalls
   /bin/sh /home/l/latest/xxx/scripts/checksyscalls.sh gcc 
-Wp,-MD,./.missing-syscalls.d  -nostdinc -isystem 
/usr/lib64/gcc/x86_64-suse-linux/4.3/include -Iinclude -Iinclude2 
-I/home/l/latest/xxx/include -I/home/l/latest/xxx/arch/x86/include 
-include include/linux/autoconf.h  -I/home/l/latest/xxx/. -I. 
-D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs 
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration 
-Os -m64 -mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time 
-maccumulate-outgoing-args -fstack-protector -fstack-protector-all 
-DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-fno-omit-frame-pointer -fno-optimize-sibling-calls -pg 
-Wdeclaration-after-statement -Wno-pointer-sign   -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(missing_syscalls)" 
-D"KBUILD_MODNAME=KBUILD_STR(missing_syscalls)" -D"DEBUG_HASH=8" 
-D"DEBUG_HASH2=54"
make -f /home/l/latest/xxx/scripts/Makefile.build obj=scripts
make -f /home/l/latest/xxx/scripts/Makefile.build obj=scripts/genksyms
make -f /home/l/latest/xxx/scripts/Makefile.build obj=scripts/mod
make -f /home/l/latest/xxx/scripts/Makefile.build obj=scripts/selinux
make -f /home/l/latest/xxx/scripts/Makefile.build obj=scripts/selinux/mdp
make -f /home/l/latest/xxx/scripts/Makefile.build obj=init
/bin/sh /home/l/latest/xxx/scripts/mkcompile_h include/linux/compile.h \
         "x86_64" "y" "" "gcc -Wall -Wundef -Wstrict-prototypes 
-Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Os -m64 -mtune=generic 
-mno-red-zone -mcmodel=kernel -funit-at-a-time 
-maccumulate-outgoing-args -fstack-protector -fstack-protector-all 
-DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
  -fno-omit-frame-pointer -fno-optimize-sibling-calls -pg 
-Wdeclaration-after-statement -Wno-pointer-sign"
make -f /home/l/latest/xxx/scripts/Makefile.build obj=usr
/bin/sh /home/l/latest/xxx/scripts/gen_initramfs_list.sh -l -d > 
usr/.initramfs_data.cpio.gz.d
make -f /home/l/latest/xxx/scripts/Makefile.build obj=arch/x86/xen
...

> I cannot try to reproduce locally as my current setup does not
> support 64 bit x86 builds.

Doesn't work with
$ make O=../a/ttt/ SUBARCH=i386 arch/x86/kernel/head32.o
and defconfig either here.

I'm at mmotm 2009-02-20-15-52 which is based on
aa0f1f110f4cbbbb83fbac36f71651b232cd8b32
from next/master.

> Does anyone else see the same?

Yup :P.

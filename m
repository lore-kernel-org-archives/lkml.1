Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbXHCJjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbXHCJjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 05:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757765AbXHCJjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 05:39:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:40171 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287AbXHCJjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 05:39:10 -0400
In-Reply-To: <200708021214.51705.m.kozlowski@tuxland.pl>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708011002.30962.m.kozlowski@tuxland.pl> <18096.24918.111376.805855@cargo.ozlabs.ibm.com> <200708021214.51705.m.kozlowski@tuxland.pl>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1C929A99-BA1D-452C-AD54-66D42DBC8D23@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: 2.6.23-rc1-mm2
Date: Fri, 3 Aug 2007 04:39:57 -0500
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2, 2007, at 5:14 AM, Mariusz Kozlowski wrote:

>>> Second issue as reported earilier allmodconfig fails to build on  
>>> imac g3.
>>
>> Do you really mean g3?  If so it's a 32-bit kernel and it  
>> shouldn't be
>> building lparmap.s.  Or do you mean G5?
>
> Yes it is iMac G3. More or less sth like this:
> http://upload.wikimedia.org/wikipedia/commons/c/c0/IMac_Bondi_Blue.jpg
>
> processor       : 0
> cpu             : 740/750
> temperature     : 47-49 C (uncalibrated)
> clock           : 400MHz
> revision        : 2.2 (pvr 0008 0202)
> bogomips        : 796.67
> machine         : PowerMac2,1
> motherboard     : PowerMac2,1 MacRISC2 MacRISC Power Macintosh
> detected as     : 66 (iMac FireWire)
> pmac flags      : 00000005
> L2 cache        : 512K unified
> memory          : 256MB
> pmac-generation : NewWorld
>
>>>   CC      arch/powerpc/kernel/lparmap.s
>>>   AS      arch/powerpc/kernel/head_64.o
>>> lparmap.c: Assembler messages:
>>> lparmap.c:84: Error: file number 1 already allocated
>>> make[1]: *** [arch/powerpc/kernel/head_64.o] Blad 1
>>> make: *** [arch/powerpc/kernel] Blad 2
>>
>> Weird.  Could you do make V=1 and send me the output?
>
> Ok. Here it goes. The last screen. If you need all / more feel free  
> to mail
> me. Config is attached - please note that this is default  
> allmodconfig.
>
>
>
> gcc -m64 -Wp,-MD,arch/powerpc/kernel/.machine_kexec.o.d  -nostdinc - 
> isystem /usr/lib/gcc/powerpc-linux-gnu/4.1.2/include -D__KERNEL__ - 
> Iinclude  -include
> include/linux/autoconf.h  -Wall -Wundef -Wstrict-prototypes -Wno- 
> trigraphs -fno-strict-aliasing -fno-common -Werror-implicit- 
> function-declaration -Os -msoft-float -pipe -mminimal-toc - 
> mtraceback=none  -mcall-aixdesc -mcpu=power4 -mno-altivec -funit-at- 
> a-time -mno-string -Wa,-maltivec -fomit-frame-pointer -g  -fno- 
> stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  - 
> mno-minimal-toc   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR 
> (machine_kexec)"  -D"KBUILD_MODNAME=KBUILD_STR(machine_kexec)" -c -o
> arch/powerpc/kernel/.tmp_machine_kexec.o arch/powerpc/kernel/ 
> machine_kexec.c
>
> gcc -m64 -Wp,-MD,arch/powerpc/kernel/.crash.o.d  -nostdinc - 
> isystem /usr/lib/gcc/powerpc-linux-gnu/4.1.2/include -D__KERNEL__ - 
> Iinclude  -include
> include/linux/autoconf.h  -Wall -Wundef -Wstrict-prototypes -Wno- 
> trigraphs -fno-strict-aliasing -fno-common -Werror-implicit- 
> function-declaration -Os -msoft-float -pipe -mminimal-toc - 
> mtraceback=none  -mcall-aixdesc -mcpu=power4 -mno-altivec -funit-at- 
> a-time -mno-string -Wa,-maltivec -fomit-frame-pointer -g  -fno- 
> stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  - 
> mno-minimal-toc   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR 
> (crash)"  -D"KBUILD_MODNAME=KBUILD_STR(crash)" -c -o
> arch/powerpc/kernel/.tmp_crash.o arch/powerpc/kernel/crash.c
>
> gcc -m64 -Wp,-MD,arch/powerpc/kernel/.machine_kexec_64.o.d  - 
> nostdinc -isystem /usr/lib/gcc/powerpc-linux-gnu/4.1.2/include - 
> D__KERNEL__ -Iinclude  -include
> include/linux/autoconf.h  -Wall -Wundef -Wstrict-prototypes -Wno- 
> trigraphs -fno-strict-aliasing -fno-common -Werror-implicit- 
> function-declaration -Os -msoft-float -pipe -mminimal-toc - 
> mtraceback=none  -mcall-aixdesc -mcpu=power4 -mno-altivec -funit-at- 
> a-time -mno-string -Wa,-maltivec -fomit-frame-pointer -g  -fno- 
> stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  - 
> mno-minimal-toc   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR 
> (machine_kexec_64)"  -D"KBUILD_MODNAME=KBUILD_STR 
> (machine_kexec_64)" -c -o
> arch/powerpc/kernel/.tmp_machine_kexec_64.o
> arch/powerpc/kernel/machine_kexec_64.c
>
> gcc -m64 -Wp,-MD,arch/powerpc/kernel/.audit.o.d  -nostdinc - 
> isystem /usr/lib/gcc/powerpc-linux-gnu/4.1.2/include -D__KERNEL__ - 
> Iinclude  -include
> include/linux/autoconf.h  -Wall -Wundef -Wstrict-prototypes -Wno- 
> trigraphs -fno-strict-aliasing -fno-common -Werror-implicit- 
> function-declaration -Os -msoft-float -pipe -mminimal-toc - 
> mtraceback=none  -mcall-aixdesc -mcpu=power4 -mno-altivec -funit-at- 
> a-time -mno-string -Wa,-maltivec -fomit-frame-pointer -g  -fno- 
> stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  - 
> mno-minimal-toc   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR 
> (audit)"  -D"KBUILD_MODNAME=KBUILD_STR(audit)" -c -o
> arch/powerpc/kernel/.tmp_audit.o arch/powerpc/kernel/audit.c
>
> gcc -m64 -Wp,-MD,arch/powerpc/kernel/.swsusp_64.o.d  -nostdinc - 
> isystem /usr/lib/gcc/powerpc-linux-gnu/4.1.2/include -D__KERNEL__ - 
> Iinclude  -include
> include/linux/autoconf.h  -Wall -Wundef -Wstrict-prototypes -Wno- 
> trigraphs -fno-strict-aliasing -fno-common -Werror-implicit- 
> function-declaration -Os -msoft-float -pipe -mminimal-toc - 
> mtraceback=none  -mcall-aixdesc -mcpu=power4 -mno-altivec -funit-at- 
> a-time -mno-string -Wa,-maltivec -fomit-frame-pointer -g  -fno- 
> stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  - 
> mno-minimal-toc   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR 
> (swsusp_64)"  -D"KBUILD_MODNAME=KBUILD_STR(swsusp_64)" -c -o
> arch/powerpc/kernel/.tmp_swsusp_64.o arch/powerpc/kernel/swsusp_64.c
>
> gcc -m64 -Wp,-MD,arch/powerpc/kernel/.swsusp_asm64.o.d  -nostdinc - 
> isystem /usr/lib/gcc/powerpc-linux-gnu/4.1.2/include -D__KERNEL__ - 
> Iinclude  -include
> include/linux/autoconf.h  -D__ASSEMBLY__  -Wa,-maltivec  - 
> gdwarf2    -c -o
> arch/powerpc/kernel/swsusp_asm64.o arch/powerpc/kernel/swsusp_asm64.S
>
> gcc -m64 -Wp,-MD,arch/powerpc/kernel/.compat_audit.o.d  -nostdinc - 
> isystem /usr/lib/gcc/powerpc-linux-gnu/4.1.2/include -D__KERNEL__ - 
> Iinclude  -include
> include/linux/autoconf.h  -Wall -Wundef -Wstrict-prototypes -Wno- 
> trigraphs -fno-strict-aliasing -fno-common -Werror-implicit- 
> function-declaration -Os -msoft-float -pipe -mminimal-toc - 
> mtraceback=none  -mcall-aixdesc -mcpu=power4 -mno-altivec -funit-at- 
> a-time -mno-string -Wa,-maltivec -fomit-frame-pointer -g  -fno- 
> stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  - 
> mno-minimal-toc   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR 
> (compat_audit)"  -D"KBUILD_MODNAME=KBUILD_STR(compat_audit)" -c -o
> arch/powerpc/kernel/.tmp_compat_audit.o arch/powerpc/kernel/ 
> compat_audit.c
>    ld -m elf64ppc   -r -o arch/powerpc/kernel/built-in.o
> arch/powerpc/kernel/semaphore.o arch/powerpc/kernel/cputable.o
> arch/powerpc/kernel/ptrace.o arch/powerpc/kernel/syscalls.o
> arch/powerpc/kernel/irq.o arch/powerpc/kernel/align.o
> arch/powerpc/kernel/signal_32.o arch/powerpc/kernel/pmc.o
> arch/powerpc/kernel/vdso.o arch/powerpc/kernel/init_task.o
> arch/powerpc/kernel/process.o arch/powerpc/kernel/systbl.o
> arch/powerpc/kernel/idle.o arch/powerpc/kernel/signal.o
> arch/powerpc/kernel/vdso32/built-in.o arch/powerpc/kernel/setup_64.o
> arch/powerpc/kernel/binfmt_elf32.o arch/powerpc/kernel/sys_ppc32.o
> arch/powerpc/kernel/signal_64.o arch/powerpc/kernel/ptrace32.o
> arch/powerpc/kernel/paca.o arch/powerpc/kernel/cpu_setup_ppc970.o
> arch/powerpc/kernel/cpu_setup_pa6t.o arch/powerpc/kernel/firmware.o
> arch/powerpc/kernel/sysfs.o arch/powerpc/kernel/nvram_64.o
> arch/powerpc/kernel/vdso64/built-in.o arch/powerpc/kernel/vecemu.o
> arch/powerpc/kernel/vector.o arch/powerpc/kernel/idle_power4.o
> arch/powerpc/kernel/of_device.o arch/powerpc/kernel/of_platform.o
> arch/powerpc/kernel/prom_parse.o arch/powerpc/kernel/proc_ppc64.o
> arch/powerpc/kernel/rtas.o arch/powerpc/kernel/rtas-rtc.o
> arch/powerpc/kernel/rtas_pci.o arch/powerpc/kernel/rtas-proc.o
> arch/powerpc/kernel/lparcfg.o arch/powerpc/kernel/vio.o
> arch/powerpc/kernel/ibmebus.o arch/powerpc/kernel/smp-tbsync.o
> arch/powerpc/kernel/crash_dump.o arch/powerpc/kernel/swsusp.o
> arch/powerpc/kernel/suspend.o arch/powerpc/kernel/time.o
> arch/powerpc/kernel/prom.o arch/powerpc/kernel/traps.o
> arch/powerpc/kernel/setup-common.o arch/powerpc/kernel/udbg.o
> arch/powerpc/kernel/misc.o arch/powerpc/kernel/io.o
> arch/powerpc/kernel/misc_64.o arch/powerpc/kernel/dma_64.o
> arch/powerpc/kernel/iommu.o arch/powerpc/kernel/prom_init.o
> arch/powerpc/kernel/ppc_ksyms.o arch/powerpc/kernel/btext.o
> arch/powerpc/kernel/smp.o arch/powerpc/kernel/kprobes.o
> arch/powerpc/kernel/legacy_serial.o arch/powerpc/kernel/udbg_16550.o
> arch/powerpc/kernel/kgdb.o arch/powerpc/kernel/kgdb_setjmp64.o
> arch/powerpc/kernel/module_64.o arch/powerpc/kernel/pci_64.o
> arch/powerpc/kernel/pci_dn.o arch/powerpc/kernel/isa-bridge.o
> arch/powerpc/kernel/pci-common.o arch/powerpc/kernel/msi.o
> arch/powerpc/kernel/machine_kexec.o arch/powerpc/kernel/crash.o
> arch/powerpc/kernel/machine_kexec_64.o arch/powerpc/kernel/audit.o
> arch/powerpc/kernel/swsusp_64.o arch/powerpc/kernel/swsusp_asm64.o
> arch/powerpc/kernel/compat_audit.o
>
> gcc -m64 -Wp,-MD,arch/powerpc/kernel/.lparmap.s.d  -nostdinc - 
> isystem /usr/lib/gcc/powerpc-linux-gnu/4.1.2/include -D__KERNEL__ - 
> Iinclude  -include
> include/linux/autoconf.h  -Wall -Wundef -Wstrict-prototypes -Wno- 
> trigraphs -fno-strict-aliasing -fno-common -Werror-implicit- 
> function-declaration -Os -msoft-float -pipe -mminimal-toc - 
> mtraceback=none  -mcall-aixdesc -mcpu=power4 -mno-altivec -funit-at- 
> a-time -mno-string -Wa,-maltivec -fomit-frame-pointer -g  -fno- 
> stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  - 
> mno-minimal-toc   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR 
> (lparmap)"  -D"KBUILD_MODNAME=KBUILD_STR(lparmap)" -fverbose-asm -S -o
> arch/powerpc/kernel/lparmap.s arch/powerpc/kernel/lparmap.c
>
> gcc -m64 -Wp,-MD,arch/powerpc/kernel/.head_64.o.d  -nostdinc - 
> isystem /usr/lib/gcc/powerpc-linux-gnu/4.1.2/include -D__KERNEL__ - 
> Iinclude  -include
> include/linux/autoconf.h  -D__ASSEMBLY__  -Wa,-maltivec  -gdwarf2  - 
> Iarch/powerpc/kernel  -c -o
> arch/powerpc/kernel/head_64.o arch/powerpc/kernel/head_64.S
> lparmap.c: Assembler messages:
> lparmap.c:84: Error: file number 1 already allocated
> make[1]: *** [arch/powerpc/kernel/head_64.o] Blad 1
> make: *** [arch/powerpc/kernel] Blad 2

Some how your defconfig is targeting a PPC64 box:

CONFIG_PPC64=y

shouldn't be set if you want to build a kernel for a G3 imac.

- k

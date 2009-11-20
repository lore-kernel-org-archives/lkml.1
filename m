Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZKTGNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZKTGNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 01:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZKTGNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 01:13:16 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:64546 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZKTGNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 01:13:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IgemyRK3vzu7JhUEB/lYPgOR7CPtbHeomIg4GeTrhOvmmXbENtz+dUiiY7l0+vAXFe
         ozTlRTjd5wrJruyAdBOZOnzNXgCFlaAqpzDk0YW0Hmk/C8QQtzingAyUozQUrCsppRjl
         euxfrS6gdGdeSMxNItCxW3OPU9u4X9FZFt/F0=
MIME-Version: 1.0
In-Reply-To: <200911200501.nAK51SYc019858@deneb.dwf.com>
References: <200911200501.nAK51SYc019858@deneb.dwf.com>
Date: Fri, 20 Nov 2009 17:13:21 +1100
Message-ID: <d45a3acc0911192213n49c0253dl11d823a23d481042@mail.gmail.com>
Subject: Re: Problems building 2.6.31.6 with 64bit Fedora-11
From: andrew hendry <andrew.hendry@gmail.com>
To: Reg Clemens <reg@dwf.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What arch are you building on?

What does 'file' say about the bad object files?
eg file vmlinux.o
vmlinux.o: ELF 64-bit LSB relocatable, AMD x86-64, version 1 (SYSV),
not stripped


On Fri, Nov 20, 2009 at 4:01 PM, Reg Clemens <reg@dwf.com> wrote:
> OK, Im new to Fedora-11, and this will be my first 64bit
> kernel build, so this is probably going to be something
> stupid, but I dont see it.
>
> The top of my .config file reads:
>
> ---
>
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.31.6-PPS
> # Thu Nov 19 20:08:27 2009
> #
> CONFIG_64BIT=y
> # CONFIG_X86_32 is not set
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
>
> ---
>
> So it seems that I am really doing a 64bit build, but the problems
> start with the first cc/ld, viz
>
> ---
>
> [root@deneb linux-2.6.31.6-PPS]# make -j3 mod
> ules ; make -j3 bzImage
>  HOSTLD  scripts/kconfig/conf
> scripts/kconfig/conf -s arch/x86/Kconfig
>  CHK     include/linux/version.h
>  UPD     include/linux/version.h
>  CHK     include/linux/utsrelease.h
>  UPD     include/linux/utsrelease.h
>  SYMLINK include/asm -> include/asm-x86
>  HOSTCC  scripts/kallsyms
>  CC      scripts/mod/empty.o
>  HOSTCC  scripts/selinux/mdp/mdp
> nm: scripts/mod/empty.o: File format not recognized
> objdump: scripts/mod/empty.o: File format not recognized
>  HOSTCC  scripts/mod/mk_elfconfig
>  HOSTCC  scripts/pnmtologo
>  MKELF   scripts/mod/elfconfig.h
>  HOSTCC  scripts/mod/file2alias.o
>  HOSTCC  scripts/mod/modpost.o
>  HOSTCC  scripts/mod/sumversion.o
>  HOSTCC  scripts/conmakehash
>  HOSTLD  scripts/mod/modpost
>  CC      kernel/bounds.s
>  GEN     include/linux/bounds.h
>  CC      arch/x86/kernel/asm-offsets.s
>  GEN     include/asm/asm-offsets.h
>  CALL    scripts/checksyscalls.sh
>  CC [M]  arch/x86/crypto/crc32c-intel.o
>  CC [M]  arch/x86/kernel/test_nx.o
>  CC [M]  arch/x86/kernel/microcode_core.o
> nm: arch/x86/crypto/crc32c-intel.o: File format not recognized
> nm: arch/x86/kernel/test_nx.o: File format not recognized
> objdump: arch/x86/kernel/test_nx.o: File format not recognized
> objdump: arch/x86/crypto/crc32c-intel.o: File format not recognized
>  CC [M]  arch/x86/kvm/svm.o
>  CC [M]  arch/x86/kvm/vmx.o
> nm: arch/x86/kernel/microcode_core.o: File format not recognized
>
> ---
>
> So whats going on here?
> Why the file-format-not-recognized ???
>
> --
>                                        Reg.Clemens
>                                        reg@dwf.com
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

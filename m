Return-Path: <linux-kernel-owner+w=401wt.eu-S933538AbZKXRWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538AbZKXRWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933492AbZKXRWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:22:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655AbZKXRWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:22:39 -0500
Date: Tue, 24 Nov 2009 18:22:08 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: cannot compile linux-2.6-tip tree
Message-ID: <20091124172208.GG1975@jolsa.lab.eng.brq.redhat.com>
References: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
 <20091124154511.GG21821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124154511.GG21821@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 04:45:11PM +0100, Ingo Molnar wrote:
> 
> * Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > drivers/pnp/card.o: file not recognized: File format not recognized
> > make[1]: *** [drivers/pnp/built-in.o] Error 1
> 
> that typically happens if you Ctrl-C a parallel kernel build, and GCC 
> leaves around an empty .o file.
> 
> It's rare but happens. 'make clean' will cure that.
> 
> 	Ingo

I tried make clean and it did not help..

I'm not sure if I'm not overlooking something obvious or am getting
crazy, but this is what I've done so far:

I took gcc command line for drivers/pnp/card.o and drivers/pnp/core.o
from make V=1 and run it manually ending up with this:


compile:
[jolsa@jolsa linux-2.6-tip]$ gcc -Wp,-MD,drivers/pnp/.card.o.d
-nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.4.2/include
-Iinclude  -I/mnt/sda5/data/upstream/linux-2.6-tip/arch/x86/include
-include include/linux/autoconf.h -D__KERNEL__ -Wall -Wundef
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
-Werror-implicit-function-declaration -Wno-format-security
-fno-delete-null-pointer-checks -O2 -m64 -mtune=generic -mno-red-zone
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args
-DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
-Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer
-fno-optimize-sibling-calls -g -pg -Wdeclaration-after-statement
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm
-fconserve-stack   -D"KBUILD_STR(s)=#s"
-D"KBUILD_BASENAME=KBUILD_STR(card)"
-D"KBUILD_MODNAME=KBUILD_STR(card)"  -c -o drivers/pnp/.tmp_card.o
drivers/pnp/card.c
[jolsa@jolsa linux-2.6-tip]$ gcc -Wp,-MD,drivers/pnp/.core.o.d
-nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.4.2/include
-Iinclude  -I/mnt/sda5/data/upstream/linux-2.6-tip/arch/x86/include
-include include/linux/autoconf.h -D__KERNEL__ -Wall -Wundef
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
-Werror-implicit-function-declaration -Wno-format-security
-fno-delete-null-pointer-checks -O2 -m64 -mtune=generic -mno-red-zone
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args
-DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
-Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer
-fno-optimize-sibling-calls -g -pg -Wdeclaration-after-statement
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm
-fconserve-stack   -D"KBUILD_STR(s)=#s"
-D"KBUILD_BASENAME=KBUILD_STR(core)"
-D"KBUILD_MODNAME=KBUILD_STR(core)"  -c -o drivers/pnp/.tmp_core.o
drivers/pnp/core.c


run objdump:
[jolsa@jolsa linux-2.6-tip]$ objdump -R drivers/pnp/.tmp_core.o 

drivers/pnp/.tmp_core.o:     file format elf64-x86-64

objdump: drivers/pnp/.tmp_core.o: not a dynamic object
objdump: drivers/pnp/.tmp_core.o: Invalid operation
[jolsa@jolsa linux-2.6-tip]$ objdump -R drivers/pnp/.tmp_card.o
objdump: drivers/pnp/.tmp_card.o: File truncated


run file:
[jolsa@jolsa linux-2.6-tip]$ file drivers/pnp/.tmp_card.o 
drivers/pnp/.tmp_card.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), stripped
[jolsa@jolsa linux-2.6-tip]$ file drivers/pnp/.tmp_core.o 
drivers/pnp/.tmp_core.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped


I checked other objects in drivers/pnp/ and for some reason the file command shows 
card.o (the object which is failing) as "stripped" and others as "not stripped" ... no idea why :)


I'm probably going to clone new tree... :)

jirka

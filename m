Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYHTA1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYHTA1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYHTA1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:27:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566AbYHTA1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:27:15 -0400
Date: Tue, 19 Aug 2008 17:26:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: sfr@canb.auug.org.au, sam@ravnborg.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, sameo@openedhand.com
Subject: Re: linux-next: Tree for August 19 (mfd/ucb)
Message-Id: <20080819172657.2f20cf91.akpm@linux-foundation.org>
In-Reply-To: <20080819170517.04d91de8.randy.dunlap@oracle.com>
References: <20080819185454.d9c74915.sfr@canb.auug.org.au>
	<20080819170517.04d91de8.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 17:05:17 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> drivers/mfd/ucb1400 is a sound (AC97) driver, so it should depend
> on AC97_BUS, like in the patch below.  However, with that patch in
> place, oldconfig goes belly up on me:
> 
> 
> linux-next-20080819> make ARCH=x86_64  O=X64  V=1 oldconfig
> make -C /local/linsrc/linux-next-20080819/X64 \
> 	KBUILD_SRC=/local/linsrc/linux-next-20080819 \
> 	KBUILD_EXTMOD="" -f /local/linsrc/linux-next-20080819/Makefile \
> 	oldconfig
> make -f /local/linsrc/linux-next-20080819/scripts/Makefile.build obj=scripts/basic
> /bin/sh /local/linsrc/linux-next-20080819/scripts/mkmakefile \
> 	    /local/linsrc/linux-next-20080819 /local/linsrc/linux-next-20080819/X64 2 6
>   GEN     /local/linsrc/linux-next-20080819/X64/Makefile
> mkdir -p include/linux include/config
> make -f /local/linsrc/linux-next-20080819/scripts/Makefile.build obj=scripts/kconfig oldconfig
> scripts/kconfig/conf -o arch/x86/Kconfig
> make[2]: *** [oldconfig] Segmentation fault (core dumped)
> make[1]: *** [oldconfig] Error 2

I'm hitting that segfault as well:

akpm2:/usr/src/25> scripts/kconfig/conf -o arch/ia64/Kconfig
init/Kconfig:5:warning: environment variable KERNELVERSION undefined
zsh: segmentation fault (core dumped)  scripts/kconfig/conf -o arch/ia64/Kconfig


Can't find the core file - wtf?  Plan B:


akpm2:/usr/src/25> gdb scripts/kconfig/conf
...
This GDB was configured as "x86_64-redhat-linux-gnu"...(no debugging symbols found)

why don't we build these things with -g by default?  grump.

(gdb) r -o arch/ia64/Kconfig 
Starting program: /usr/src/devel/scripts/kconfig/conf -o arch/ia64/Kconfig
Failed to read a valid object file image from memory.
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
init/Kconfig:5:warning: environment variable KERNELVERSION undefined

Program received signal SIGSEGV, Segmentation fault.
0x000000000040419c in sym_check_deps ()
(gdb) bt
#0  0x000000000040419c in sym_check_deps ()
#1  0x0000000000404099 in sym_check_expr_deps ()
#2  0x000000000040412c in sym_check_sym_deps ()
#3  0x00000000004042f5 in sym_check_deps ()
#4  0x0000000000404099 in sym_check_expr_deps ()
#5  0x000000000040412c in sym_check_sym_deps ()
#6  0x00000000004042f5 in sym_check_deps ()
#7  0x0000000000404099 in sym_check_expr_deps ()
#8  0x0000000000404099 in sym_check_expr_deps ()
#9  0x0000000000404099 in sym_check_expr_deps ()
#10 0x0000000000404099 in sym_check_expr_deps ()
#11 0x0000000000404099 in sym_check_expr_deps ()
#12 0x0000000000404099 in sym_check_expr_deps ()
#13 0x00000000004040f2 in sym_check_sym_deps ()
#14 0x00000000004042f5 in sym_check_deps ()
#15 0x000000000040412c in sym_check_sym_deps ()
#16 0x00000000004042f5 in sym_check_deps ()
#17 0x000000000040412c in sym_check_sym_deps ()
#18 0x00000000004042f5 in sym_check_deps ()
#19 0x000000000040bb83 in conf_parse ()
#20 0x000000000040269c in main ()

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbZEFRwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbZEFRwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbZEFRvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:51:51 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:59035 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759649AbZEFRvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:51:46 -0400
Message-ID: <4A01CE8D.4060608@oracle.com>
Date: Wed, 06 May 2009 10:53:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: bugme-daemon@bugzilla.kernel.org
CC: jason.faulkner@rackspace.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 13255] New: 2.6.27.22 compile errors in setup.c; 2.6.27
 compiles perfect on same .config
References: <bug-13255-10286@http.bugzilla.kernel.org/>
In-Reply-To: <bug-13255-10286@http.bugzilla.kernel.org/>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A01CE27.0161:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13255
> 
>            Summary: 2.6.27.22 compile errors in setup.c; 2.6.27 compiles
>                     perfect on same .config
>            Product: Other
>            Version: 2.5
>     Kernel Version: 2.6.27.10
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: other_other@kernel-bugs.osdl.org
>         ReportedBy: jason.faulkner@rackspace.com
>         Regression: Yes
> 
> 
> Created an attachment (id=21246)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=21246)
> .config in which the compilation error occurs
> 
> I have a .config (attached) which compiles on 2.6.27, but doesn't compile on
> 2.6.27.22 -- output follows:
> 
> After some troubleshooting, I've discovered the regression was introduced in
> the 2.6.27.10 release (2.6.27.[10-22] will not compile; 2.6.27.[1-9] will)
> 
> # make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CC      arch/x86/kernel/asm-offsets.s
>   GEN     include/asm/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
>   HOSTCC  scripts/genksyms/genksyms.o
>   HOSTCC  scripts/genksyms/lex.o
>   HOSTCC  scripts/genksyms/parse.o
>   HOSTLD  scripts/genksyms/genksyms
>   CC      scripts/mod/empty.o
>   HOSTCC  scripts/mod/mk_elfconfig
>   MKELF   scripts/mod/elfconfig.h
>   HOSTCC  scripts/mod/file2alias.o
>   HOSTCC  scripts/mod/modpost.o
>   HOSTCC  scripts/mod/sumversion.o
>   HOSTLD  scripts/mod/modpost
>   HOSTCC  scripts/kallsyms
>   HOSTCC  scripts/conmakehash
>   HOSTCC  scripts/bin2c
>   CC      init/main.o
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   CC      init/do_mounts.o
>   CC      init/do_mounts_initrd.o
>   LD      init/mounts.o
>   CC      init/initramfs.o
>   CC      init/calibrate.o
>   LD      init/built-in.o
>   HOSTCC  usr/gen_init_cpio
>   GEN     usr/initramfs_data.cpio.gz
>   AS      usr/initramfs_data.o
>   LD      usr/built-in.o
>   CC      arch/x86/kernel/process_64.o
>   CC      arch/x86/kernel/signal_64.o
>   AS      arch/x86/kernel/entry_64.o
>   CC      arch/x86/kernel/traps_64.o
>   CC      arch/x86/kernel/irq_64.o
>   CC      arch/x86/kernel/time_64.o
>   CC      arch/x86/kernel/ioport.o
>   CC      arch/x86/kernel/ldt.o
>   CC      arch/x86/kernel/setup.o
> arch/x86/kernel/setup.c: In function âsetup_archâ:
> arch/x86/kernel/setup.c:714: error: implicit declaration of function
> âvmi_activateâ
> make[1]: *** [arch/x86/kernel/setup.o] Error 1
> make: *** [arch/x86/kernel] Error 2


I can't reproduce this problem with your .config file.
I tried both 2.6.27.10 and 2.6.27.22 and they both built
successfully.  And in looking at the stable 2.6.27.10 patch,
I don't see any problem with it (regarding vmi_activate()).

Did you download the linux-2.6.27.zz.tar.{bz2,gz} tarball
or did you apply some patch(es) to linux-2.6.27 or what?


-- 
~Randy

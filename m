Return-Path: <linux-kernel-owner+w=401wt.eu-S965838AbXCVHaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965838AbXCVHaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965847AbXCVHap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:30:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57902 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965838AbXCVHan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:30:43 -0400
Date: Thu, 22 Mar 2007 07:30:42 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: $CHECK can't be overridden
Message-ID: <20070322073042.GT4095@ftp.linux.org.uk>
References: <20070322051525.GD17159@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322051525.GD17159@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 01:15:25AM -0400, Dave Jones wrote:
> make help implies that supplying $CHECK on the command line
> should override sparse as the checker used when building with C=1
> Yet, this doesn't seem to be the case.
> 
> This would be useful for cases where for eg, sparse isn't in
> the $PATH, allowing an explicit path to the executable to be
> passed in automated build environments.

Eh?  Works fine here...

aviro@icy:/usr/src/cross-kernel/audit$ cat >/tmp/foo <<'EOF'
#!/bin/sh
echo "$@"
EOF
aviro@icy:/usr/src/cross-kernel/audit$ chmod +x /tmp/foo
aviro@icy:/usr/src/cross-kernel/audit$ make clean
  CLEAN   /usr/src/cross-kernel/audit
  CLEAN   .tmp_versions
aviro@icy:/usr/src/cross-kernel/audit$ make CHECK=/tmp/foo C=1
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  CC      arch/x86_64/kernel/asm-offsets.s
  GEN     include/asm-x86_64/asm-offsets.h
  HOSTCC  scripts/genksyms/genksyms.o
  HOSTCC  scripts/genksyms/lex.o
  HOSTCC  scripts/genksyms/parse.o
  HOSTLD  scripts/genksyms/genksyms
  CHECK   scripts/mod/empty.c
-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise -D__x86_64__ -m64 -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.0.2/include -Wp,-MD,scripts/mod/.empty.o.d -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.0.2/include -D__KERNEL__ -Iinclude -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Os -m64 -mno-red-zone -mcmodel=kernel -pipe -fno-reorder-blocks -Wno-sign-compare -fno-asynchronous-unwind-tables -funit-at-a-time -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -Wdeclaration-after-statement -Wno-pointer-sign -ffunction-sections -DKBUILD_STR(s)=#s -DKBUILD_BASENAME=KBUILD_STR(empty) -DKBUILD_MODNAME=KBUILD_STR(empty) scripts/mod/empty.c
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
^C
make[2]: *** [scripts/mod/file2alias.o] Interrupt
make[1]: *** [scripts/mod] Interrupt
make: *** [scripts] Interrupt

Gets executed just fine...

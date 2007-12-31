Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbXLaNQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbXLaNQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 08:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXLaNQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 08:16:19 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:41526 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXLaNQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 08:16:19 -0500
Date: Mon, 31 Dec 2007 14:16:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Jones <davej@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Recursive variable `KBUILD_CFLAGS' references itself (eventually).
Message-ID: <20071231131619.GE21871@uranus.ravnborg.org>
References: <20071120001445.GA9243@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120001445.GA9243@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 07:14:45PM -0500, Dave Jones wrote:
> Trying to do a 32bit build on a 64bit machine.
> I did..
>   make ARCH=i386 oldconfig
>   make ARCH=i386 arch/x86/
> 
> and got..
> 
> scripts/kconfig/conf -s arch/x86/Kconfig
>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   HOSTCC  scripts/kallsyms
>   HOSTCC  scripts/conmakehash
>   CC      scripts/mod/empty.o
>   HOSTCC  scripts/mod/mk_elfconfig
>   HOSTCC  scripts/bin2c
>   MKELF   scripts/mod/elfconfig.h
>   HOSTCC  scripts/mod/file2alias.o
>   HOSTCC  scripts/mod/modpost.o
>   HOSTCC  scripts/mod/sumversion.o
>   HOSTLD  scripts/mod/modpost
>   CC      arch/x86/kernel/asm-offsets.s
>   GEN     include/asm-x86/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
> /mnt/raid0/src/linux-2.6/arch/x86/Makefile_32:43: *** Recursive variable `KBUILD_CFLAGS' references itself (eventually).  Stop.
> make: *** [arch/x86/] Error 2

Hi Dave.

Walking through my mailbox I found this one.
I did not get similar reports and I cannot reproduce it.

Do you continue to see this or had it been fixed somehow?
The only way I can see it heppen is that you have lost
the initial assignmnet in top-level Makefile so
make see this as an '=' assinment and not a ':='
assignment.
The first may not reference itself.

	Sam

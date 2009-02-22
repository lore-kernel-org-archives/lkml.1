Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZBVWPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZBVWPP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZBVWPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:15:01 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:57250 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZBVWPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:15:01 -0500
Date: Sun, 22 Feb 2009 23:16:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel building procedure changed?
Message-ID: <20090222221653.GA30498@uranus.ravnborg.org>
References: <20090222220747.GB7279@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222220747.GB7279@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 01:07:48AM +0300, Cyrill Gorcunov wrote:
> Hi all,
> 
> I found a bit strange thing happens now --
> plain
> 
> 	make arch/x86/kernel/head64.o
> 
> doesn't work anymore. Instead of compiling
> _just_ this file I've got the following:
> 
> ---
> cyrill@lenovo linux-2.6.git $ make arch/x86/kernel/head64.o
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   AS      arch/x86/kernel/head_64.o
>   VDSOSYM arch/x86/vdso/vdso-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-syms.lds
>   LD      arch/x86/vdso/built-in.o
>   CC      fs/hpfs/dnode.o
> make[2]: *** [fs/hpfs/dnode.o] Interrupt
> make[1]: *** [fs/hpfs] Interrupt
> make: *** [fs] Interrupt
> ---
> 
> I've done make allyesconfig previously.
> I don't understand what I'm doing wrong... :(

I should work...
Do you have CONFIG_64BIT set in your config?
Does it behave strange also for files in kernel/?
Can you postthe output of a "make V=1 arch/x86/kernel/head64.o"

I cannot try to reproduce locally as my current setup does not
support 64 bit x86 builds.
Does anyone else see the same?

	Sam

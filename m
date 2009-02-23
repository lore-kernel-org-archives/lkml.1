Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZBWHsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZBWHsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZBWHsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:48:32 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:44085 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZBWHsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:48:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cbeYxgEbFMOOfsXBAA1HO5ZCNDDBxjO5dlEYvcbO4UhP5lrWHSIEfC45AYUQYm0SDZ
         E7PJXk6SyyOYBXMto41AZytHjfoFvLjki73K2Ba5MpwmZF9qmM0GQ2gQss9cpuhENb9j
         xmOvMDCbI03mA+/8uUDup3QN9m58SvHUgqu18=
Date: Mon, 23 Feb 2009 10:48:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel building procedure changed?
Message-ID: <20090223074837.GA29898@localhost>
References: <20090222220747.GB7279@localhost> <20090222221653.GA30498@uranus.ravnborg.org> <49A1D167.8050801@gmail.com> <20090222230031.GB30619@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222230031.GB30619@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Mon, Feb 23, 2009 at 12:00:31AM +0100]
| On Sun, Feb 22, 2009 at 11:27:51PM +0100, Jiri Slaby wrote:
| > On 22.2.2009 23:16, Sam Ravnborg wrote:
| > >On Mon, Feb 23, 2009 at 01:07:48AM +0300, Cyrill Gorcunov wrote:
| > >>Hi all,
| > >>
| > >>I found a bit strange thing happens now --
| > >>plain
| > >>
| > >>	make arch/x86/kernel/head64.o
| > >>
| > >>doesn't work anymore. Instead of compiling
| > >>_just_ this file I've got the following:
| > >>
| > >>---
| > >>cyrill@lenovo linux-2.6.git $ make arch/x86/kernel/head64.o
| > >>   CHK     include/linux/version.h
| > >>   CHK     include/linux/utsrelease.h
| > >>   SYMLINK include/asm ->  include/asm-x86
| > >>   CALL    scripts/checksyscalls.sh
| > >>   CHK     include/linux/compile.h
| > >>   AS      arch/x86/kernel/head_64.o
| > >>   VDSOSYM arch/x86/vdso/vdso-syms.lds
| > >>   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
| > >>   VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
| > >>   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
| > >>   VDSOSYM arch/x86/vdso/vdso32-syms.lds
| > >>   LD      arch/x86/vdso/built-in.o
| > >>   CC      fs/hpfs/dnode.o
| > >>make[2]: *** [fs/hpfs/dnode.o] Interrupt
| > >>make[1]: *** [fs/hpfs] Interrupt
| > >>make: *** [fs] Interrupt
| > >>---
| > >>
| > >>I've done make allyesconfig previously.
| > >>I don't understand what I'm doing wrong... :(
| > >
| > >I should work...
| > 
| > It is matter of days, new mmotm doesn't work either, older did.
| 
| Does it happen with -next?
| Does it happen with mainline?
| I need to know what tree to look at - and I do not have mmotm handy.
| 
| 	Sam
| 

Sam, it seems I never paid attention on Makefile
rules before. Which means -- I don't know if kernel
build procedure should behave like it do now.

We have the following rule (arch/x86/kernel/Makefile)

extra-y                := head_$(BITS).o head$(BITS).o head.o init_task.o
vmlinux.lds

Does it mean that any obj-y targets should be built before
extra-y? If "yes" -- all is fine and works well and I'm just
noising here (sorry for that).

To be precise -- I don't remember how it worked before :)
I mean it's possible that my previous workflow was:

1) build whole kernel by "make"
2) modify head_64.S
3) run "make arch/x86/kernel/head_64.o"

So I will try to repeat these 3 points and report.

	- Cyrill -

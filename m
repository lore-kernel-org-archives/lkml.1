Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbZBLOki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbZBLOki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbZBLOk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:40:28 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:32949 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756977AbZBLOk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:40:26 -0500
Date: Thu, 12 Feb 2009 15:40:23 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Greg KH <gregkh@suse.de>, Shane Hathaway <shane@hathawaymix.org>,
       Daolong Wang <ahlongxp@gmail.com>,
       User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>,
       Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rob Landley <rob@landley.net>, Am?rico Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [uml-devel] [Patch] uml: fix a link error
In-Reply-To: <20090207125956.110591c9@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LRH.2.00.0902121539340.29413@vixen.sonytel.be>
References: <20090115194033.GA10926@hack.private> <20090116124158.4364e269.akpm@linux-foundation.org> <200901170328.15178.rob@landley.net> <dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com> <20090119152104.GC6432@c2.user-mode-linux.org>
 <dc84318c0901191746g31d51c23g65da89190dc8bfd2@mail.gmail.com> <49753063.8040007@hathawaymix.org> <alpine.LRH.2.00.0902041803360.7690@vixen.sonytel.be> <Pine.LNX.4.64.0902042115530.25136@anakin> <20090204204009.GA10680@suse.de> <Pine.LNX.4.64.0902042150550.25136@anakin>
 <20090207125956.110591c9@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009, Heiko Carstens wrote:
> On Wed, 4 Feb 2009 21:54:12 +0100 (CET)
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > I verified that Shane's solution:
> > 
> > #define sys_sigprocmask sys_kernel_sigprocmask
> > 
> > works for me, but that's definitely not the cleanest way.
> > 
> > Al Viro also had a suggestion to rework the SYSCALL_DEFINE* macros, but I
> > haven't tried it yet.
> 
> 
> Patch below should fix it.

Thanks! I only managed to try it a few minutes ago...

> Subject: [PATCH] syscall define: fix uml compile bug
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> With the new system call defines we get this on uml:
> 
> arch/um/sys-i386/built-in.o: In function `sys_call_table':
> (.rodata+0x308): undefined reference to `sys_sigprocmask'
> 
> Reason for this is that uml passes the preprocessor option
> -Dsigprocmask=kernel_sigprocmask to gcc when compiling the kernel.
> This causes SYSCALL_DEFINE3(sigprocmask, ...) to be expanded to
> SYSCALL_DEFINEx(3, kernel_sigprocmask, ...) and finally to a system call
> named sys_kernel_sigprocmask. However sys_sigprocmask is missing because
> of this.
> To avoid macro expansion for the system call name just concatenate the
> name at first define instead of carrying it through severel levels.
> This was pointed out by Al Viro.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

For the record:

Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010

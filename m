Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZBDR0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZBDR0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZBDR0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 12:26:09 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:60309 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751446AbZBDR0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 12:26:08 -0500
Date: Wed, 4 Feb 2009 18:26:06 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Shane Hathaway <shane@hathawaymix.org>
cc: Daolong Wang <ahlongxp@gmail.com>,
       User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>,
       Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rob Landley <rob@landley.net>, Am?rico Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [uml-devel] [Patch] uml: fix a link error
In-Reply-To: <49753063.8040007@hathawaymix.org>
Message-ID: <alpine.LRH.2.00.0902041803360.7690@vixen.sonytel.be>
References: <20090115194033.GA10926@hack.private>  <20090116124158.4364e269.akpm@linux-foundation.org>  <200901170328.15178.rob@landley.net>  <dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com>  <20090119152104.GC6432@c2.user-mode-linux.org>
 <dc84318c0901191746g31d51c23g65da89190dc8bfd2@mail.gmail.com> <49753063.8040007@hathawaymix.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009, Shane Hathaway wrote:
> Daolong Wang wrote:
> > On Mon, Jan 19, 2009 at 11:21 PM, Jeff Dike <jdike@addtoit.com> wrote:
> >> On Sun, Jan 18, 2009 at 02:23:46PM +0800, Daolong Wang wrote:
> >>> I can confirm this link error.
> >> In what environment?  I see no problems here.
> 
> I can also confirm this link error.  The problem occurs when compiling
> either 2.6.28.1 or 2.6.27.12; I didn't try anything earlier.  The patch
> suggested at this beginning of this thread did solve the link problem
> and the resulting kernel ran for several hours.  However, I think the
> patch is still probably incorrect.
> 
> I'm going to repost what I said in another message I sent today, this
> time with a wider audience:
> 
> The problem is that the name "sigprocmask" is getting renamed to
> "kernel_sigprocmask" by a compiler directive in arch/um/Makefile, then
> that name gets mangled into "sys_kernel_sigprocmask" by the
> SYSCALL_DEFINE3(sigprocmask, ...) macro in kernel/signal.c.
> 
> So, instead of the patch suggested earlier, I added the following line
> to arch/um/sys-i386/sys_call_table.S:
> 
> #define sys_sigprocmask sys_kernel_sigprocmask
> 
> This made it compile and link correctly.  Look at the symbols generated
> by the compile of signal.c to see what I mean:
> 
> # nm kernel/signal.o | grep sigprocmask
> 0000008f r __kstrtab_kernel_sigprocmask
> 00000040 r __ksymtab_kernel_sigprocmask
> 00001ea6 T kernel_sigprocmask
> 00002d67 T sys_kernel_sigprocmask
> 00001faf T sys_rt_sigprocmask
> 
> Unfortunately, it's a mystery to me that others haven't run into this
> before.  My host environment is RHEL 4 inside some kind of chroot.

I've just started seeing this problem with some 2.6.29-rc3 kernel...

Before, I did not have this problem with various 2.6.28-rc8 and 2.6.29-rc1
kernels (and several older versions I don't remember).

Given 2.6.29-rc1 works for me and 2.6.28.1 fails for you, I'm inclined to
believe 2.6.28 is OK. I'll give it a try...

BTW, I'm using CentOS 5.2.

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

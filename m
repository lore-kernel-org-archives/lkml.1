Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbXEQMgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbXEQMgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbXEQMgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:36:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbXEQMgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:36:05 -0400
From: Andi Kleen <ak@suse.de>
To: Dave Jones <davej@redhat.com>
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
Date: Thu, 17 May 2007 13:51:34 +0200
User-Agent: KMail/1.9.1
Cc: Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com>
In-Reply-To: <20070517004209.GE16810@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171351.34531.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 May 2007 02:42, Dave Jones wrote:
> On Thu, May 17, 2007 at 02:09:16AM +0200, Christian wrote:
>  > my small VIA C3_2 box does not boot with 2.6.22-rc1.
>  > It even does not uncompress the kernel.
>  >
>  > The configuration as M386 M486 works. But M586 + MVIAC3_2
>  > does not work.
>  >
>  > solution for me, cahnge arch/i386/Kconfig.cpu
>  >
>  > --- arch/i386/Kconfig.cpu.before     2007-05-17 01:38:26.000000000 +0200
>  > +++ arch/i386/Kconfig.cpu       2007-05-17 00:54:52.000000000 +0200
>  > @@ -299,5 +299,5 @@
>  >
>  >  config X86_CMPXCHG64
>  >         bool
>  > -       depends on !M386 && !M486
>  > +       depends on !M386 && !M486 && !MVIAC3_2
>  >         default y
>  >
>  >
>  > The related #ifdef is in ./include/asm-i386/cmpxchg.h
>  > May be cmpxchg8b is not supported by VIAC3_2 ?
>  >
>  > May be some other non Intel/AMD need to be excluded from X86_CMPXCHG64 ?
>  > May be the generic option CONFIG_X86_GENERIC need to switch this off
>  > also ?
>
> The C3s all have cx8, but it needs to be enabled in an MSR first.
> (See arch/i386/kernel/cpu/centaur.c , search for CX8)

Sigh. I wonder what genius at VIA came up with that setup.

> Did we add code that uses cmpxchg8b before identify_cpu() gets run ?
> I've not been paying attention to .22rc (busy trying to beat .21 into shape
> for F7) so I may have missed something obvious. Andi?

That would be a bit complicated in pure asm code. 
It's probably best to just not require it as in Christian's patch above.
Without SMP support it is not particularly needed anyways; a irq disabling
emulation should work.

-Andi

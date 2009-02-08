Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZBHPrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZBHPrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 10:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbZBHPrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 10:47:10 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49937 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZBHPrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 10:47:08 -0500
Date: Sun, 8 Feb 2009 07:47:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Trilok Soni <soni.trilok@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] LTTng 0.89 for Linux 2.6.29-rc3
Message-ID: <20090208154711.GA527@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090205183158.GA1969@Krystal> <20090205184456.GK6915@linux.vnet.ibm.com> <20090205202249.GA26964@Krystal> <20090205210415.GM6915@linux.vnet.ibm.com> <20090205210627.GA1313@Krystal> <20090206003308.GO6915@linux.vnet.ibm.com> <20090206020005.GA8560@Krystal> <20090206134833.GC10918@linux.vnet.ibm.com> <20090206200329.GA1824@Krystal> <20090206213701.GN10918@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090206213701.GN10918@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 01:37:01PM -0800, Paul E. McKenney wrote:
> On Fri, Feb 06, 2009 at 03:03:29PM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Thu, Feb 05, 2009 at 09:00:05PM -0500, Mathieu Desnoyers wrote:
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:

[ . . . ]

> > > > >   CC      arch/powerpc/kernel/asm-offsets.s
> > > > > In file included from include/linux/module.h:18,
> > > > >                  from include/linux/sysdev.h:25,
> > > > >                  from include/linux/node.h:22,
> > > > >                  from include/linux/swap.h:10,
> > > > >                  from include/linux/suspend.h:7,
> > > > >                  from arch/powerpc/kernel/asm-offsets.c:24:
> > > > > include/linux/immediate.h:15:27: error: asm/immediate.h: No such file or directory
> > > > > In file included from include/linux/module.h:18,
> > > > >                  from include/linux/sysdev.h:25,
> > > > >                  from include/linux/node.h:22,
> > > > >                  from include/linux/swap.h:10,
> > > > >                  from include/linux/suspend.h:7,
> > > > >                  from arch/powerpc/kernel/asm-offsets.c:24:
> > > > > include/linux/immediate.h:37: warning: â€˜struct __imvâ€™ declared
> > > > > inside parameter list
> > > > > include/linux/immediate.h:37: warning: its scope is only this definition
> > > > > or declaration, which is probably not what you want
> > > > > include/linux/immediate.h:40: warning: â€˜struct __imvâ€™ declared
> > > > > inside parameter list
> > > > > make[1]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1
> > > > > make: *** [prepare0] Error 2
> > > > > 02/05/2009-17:57:41 Build the kernel. Failed rc = 2
> > > > > 02/05/2009-17:57:41 build: Building kernel... Failed rc = 1
> > > > > 
> > > > 
> > > > Hrm, does the file
> > > > 
> > > > arch/powerpc/include/asm/immediate.h exist in your tree ?
> > > > 
> > > > Here, with the setup done following the commands I gave you (minus the
> > > > mkdir patch), I get :
> > > > 
> > > > 
> > > > compudj@ok:~$ head testpaulmck/linux-2.6.29-rc3/arch/powerpc/include/asm/immediate.h 
> > > > #ifndef _ASM_POWERPC_IMMEDIATE_H
> > > > #define _ASM_POWERPC_IMMEDIATE_H
> > > > 
> > > > /*
> > > >  * Immediate values. PowerPC architecture optimizations.
> > > >  *
> > > >  * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > >  *
> > > >  * This file is released under the GPLv2.
> > > >  * See the file COPYING for more details.
> > > > 
> > > > ....
> > > > 
> > > > Which defines struct __imv. So hrm, normally the header should be there.
> > > > (/me still confused) :)
> > > 
> > > It does indeed, see the patch I generated against 2.6.29-rc3:
> > > 
> > > 	http://www.rdrop.com/users/paulmck/patches/2.6.29-rc3-ltt-1.patch
> > > 
> > > I get a similar failure on x86 -- perhaps my tools or build environment
> > > does not match yours?
> > > 
> > 
> > Maybe. If you want a quick and dirty solution, try :
> > 
> > CONFIG_IMMEDIATE=n
> > 
> > Immediate values are just an optimization, not necessary anyway.
> 
> K -- kicking it off.

One thing that helps on 32-bit x86 is removing the "select HAVE_IMMEDIATE"
that you added to arch/x86/Kconfig.  I then get assembly errors:

	  AS      arch/x86/kernel/entry_32.o
	arch/x86/kernel/entry_32.S: Assembler messages:
	arch/x86/kernel/entry_32.S:272: Error: invalid character '_' in
	mnemonic
	make[1]: *** [arch/x86/kernel/entry_32.o] Error 1
	make: *** [arch/x86/kernel] Error 2

This seems to point to the following new line:

	INTERRUPT_RETURN_NMI_SAFE

Replacing this with the NATIVE_INTERRUPT_RETURN_NMI_SAFE that appears
elsewhere did not help.

Over to you!

							Thanx, Paul

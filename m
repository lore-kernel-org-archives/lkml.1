Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYASXvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYASXvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 18:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYASXvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 18:51:03 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53951 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbYASXvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 18:51:01 -0500
Date: Sun, 20 Jan 2008 01:49:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [lguest build regression fix] Re: 2.6.24-rc8-git1: Reported
	regressions from 2.6.23
Message-ID: <20080119234945.GF8669@does.not.exist>
References: <200801180035.42878.rjw@sisk.pl> <20080119180604.GA6224@elte.hu> <200801201024.47825.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801201024.47825.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 10:24:47AM +1100, Rusty Russell wrote:
> On Sunday 20 January 2008 05:06:04 Ingo Molnar wrote:
> > x86 randconfig testing found the following build failure:
> >
> >  arch/x86/lguest/boot.c: In function 'lazy_hcall':
> >  arch/x86/lguest/boot.c:151: error: implicit declaration of function
> > 'paravirt_get_lazy_mode' arch/x86/lguest/boot.c:151: error:
> > 'PARAVIRT_LAZY_NONE' undeclared (first use in this function)
> >
> > which i bisected down to this very fresh commit:
> >
> >  commit 84f7466ee20cc094aa38617abfa2f3834871f054
> >  Author: Rusty Russell <rusty@rustcorp.com.au>
> >  Date:   Sat Jan 19 07:02:29 2008 +1100
> >
> >      Selecting LGUEST should turn on Guest support, as in 2.6.23.
> >
> > which allows the following .config variation:
> >
> >  # CONFIG_PARAVIRT_GUEST is not set
> >  CONFIG_LGUEST_GUEST=y
> 
> This looks like a "randconfig" bug, to be honest.
> 
> CONFIG_LGUEST_GUEST and CONFIG_LGUEST are within "if PARAVIRT_GUEST" (include 
> is in arch/x86/Kconfig).

According to GNU grep we have two CONFIG_LGUEST_GUEST variables (sic), 
one in arch/x86/lguest/Kconfig and one in drivers/lguest/Kconfig.

And CONFIG_LGUEST (which selects CONFIG_LGUEST_GUEST) is in 
drivers/lguest/Kconfig which gets included from drivers/kvm/Kconfig (sic)
which in turn gets included from drivers/Kconfig which in turn is not 
within the "if PARAVIRT_GUEST".

Rusty, don't blame randconfig for finding bugs in this mess you 
created...

> Rusty.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


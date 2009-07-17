Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbZGQFRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbZGQFRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZGQFRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:17:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51255 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZGQFRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:17:39 -0400
Subject: Re: [PATCH] Convert blackfin to use arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <8bd0f97a0907161926j258da72cg9dd1ca76ea8be2fb@mail.gmail.com>
References: <1244758210.7192.5.camel@localhost.localdomain>
	 <1247790356.7398.14.camel@localhost.localdomain>
	 <8bd0f97a0907161926j258da72cg9dd1ca76ea8be2fb@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 22:17:36 -0700
Message-Id: <1247807856.674.1.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 22:26 -0400, Mike Frysinger wrote:
> On Thu, Jul 16, 2009 at 20:25, john stultz wrote:
> > This patch converts blackfin to use GENERIC_TIME via the arch_getoffset()
> > infrastructure, reducing the amount of arch specific code we need to
> > maintain.
> >
> > This patch applies on top of Linus' current -git tree (2.6.31-rc3).
> >
> > I've taken my best swing at converting this, but I'm not 100% confident
> > I got it right. My cross-compiler is now out of date (gcc4.2) so I
> > wasn't able to  check if it compiled. Any assistance from arch
> > maintainers or testers to get this merged would be great.
> 
> something seems to be off as the Blackfin defconfig now does:
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `clocksource_forward_now':
> kernel/time/timekeeping.c:82: undefined reference to `arch_gettimeoffset'
> kernel/built-in.o: In function `getnstimeofday':
> kernel/time/timekeeping.c:119: undefined reference to `arch_gettimeoffset'
> make: *** [.tmp_vmlinux1] Error 1
> 
> most likely because the Blackfin time.c is the old stuff
> (non-clocksource) while time-ts.c is the newer stuff (clocksource) and
> this change only touches time.c

Hrm.. Ok. I'll take a look. Thanks for testing and the pointer!

-john


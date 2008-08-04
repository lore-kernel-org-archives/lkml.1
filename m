Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbYHDOG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbYHDOG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYHDOGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:06:50 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59545 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbYHDOGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:06:49 -0400
Date: Mon, 4 Aug 2008 17:05:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: a.beregalov@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sparc64: build failure at sys_sparc32.c
Message-ID: <20080804140532.GI6088@cs181140183.pp.htv.fi>
References: <20080729065914.GA30878@orion> <20080729.001256.203097603.davem@davemloft.net> <a4423d670807290138p4a666337id74fe1fa637932e4@mail.gmail.com> <20080803.181934.262275514.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080803.181934.262275514.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 06:19:34PM -0700, David Miller wrote:
> From: "Alexander Beregalov" <a.beregalov@gmail.com>
> Date: Tue, 29 Jul 2008 12:38:38 +0400
> 
> > 2008/7/29 David Miller <davem@davemloft.net>:
> > > From: Alexander Beregalov <a.beregalov@gmail.com>
> > > Date: Tue, 29 Jul 2008 10:59:14 +0400
> > >
> > >> I am testing build using randconfig.
> > >>
> > >> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_chown16':
> > >> arch/sparc64/kernel/sys_sparc32.c:63: error: implicit declaration of
> > >> function 'low2highuid'
> > >> arch/sparc64/kernel/sys_sparc32.c:63: error: implicit declaration of
> > >> function 'low2highgid'
> > >> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_getresuid16':
> > >> arch/sparc64/kernel/sys_sparc32.c:106: error: implicit declaration of
> > >> function 'high2lowuid'
> > >> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_getresgid16':
> > >> arch/sparc64/kernel/sys_sparc32.c:123: error: implicit declaration of
> > >> function 'high2lowgid'
> > >>
> > >> These functions are defined in linux/highuid.h only if CONFIG_UID16 is enabled.
> > >
> > > Thanks, what kernel version is this?
> > 
> > It is current by default - .27-rc1. These files were not touched for a
> > long time.
> > But, OK, I will mention the kernel version every time.
> 
> This is basically setup to fail.
> 
> If SPARC64 && COMPAT this option should always be set.  But it's
> left as an option the user can still disable in this case down
> in init/Kconfig.
> 
> This can be triggered very likely on other platforms too.
> 
> Can someone take a look at fixing this properly?  Make it something
> that is selected on necessary platforms, for example.

The only platforms that do their own stuff instead of using the 
functions from kernel/uid16.c are sparc64 and s390.

Is there any reason why sparc64 has it's own functions?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


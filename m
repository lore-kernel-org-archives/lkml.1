Return-Path: <linux-kernel-owner+w=401wt.eu-S1761855AbYDVRWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761855AbYDVRWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbYDVRWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:22:33 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37139 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764AbYDVRWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:22:32 -0400
Date: Tue, 22 Apr 2008 20:21:56 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: #define out unused parameters of
	xfs_bmap_add_free and xfs_btree_read_bufl
Message-ID: <20080422172156.GB28933@cs181133002.pp.htv.fi>
References: <20080419142329.GA5339@elte.hu> <200804221320.54147.vda.linux@googlemail.com> <20080422142807.GD16895@cs181133002.pp.htv.fi> <200804221817.03945.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200804221817.03945.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 06:17:03PM +0200, Denys Vlasenko wrote:
> On Tuesday 22 April 2008 16:28, Adrian Bunk wrote:
> > > xfs_bmap_add_free and xfs_btree_read_bufl functions
> > > use some of their parameters only in some cases
> > > (e.g. if DEBUG is defined, or on non-Linux OS :)
> > > 
> > > This patch removes these parameters using #define hack
> > > which makes them "disappear" without the need of uglifying
> > > every callsite with #ifdefs.
> > > 
> > > Code size difference on 32-bit x86:
> > >  393457    2904    2952  399313   617d1 linux-2.6-xfs6-TEST/fs/xfs/xfs.o
> > >  393441    2904    2952  399297   617c1 linux-2.6-xfs7-TEST/fs/xfs/xfs.o
> > >...
> > 
> > Elimination of completely unused parameters makes sense, but IMHO using 
> > such #define hacks for minuscule code size and stack usage advantages is 
> > not worth it.
> 
> In busybox this trick is used extensively.

Busybox does not have more than one million lines changed in
one release.

In the Linux kernel maintainability is much more important than in 
smaller projects.

> I don't know how to eliminate these unused parameters with less
> intervention, but I also don't want to leave it unfixed.
> 
> I want to eventually reach the state with no warnings
> about unused parameters.

The standard kernel pattern in using empty static inline functions (that 
allow type checking).

And I'm not sure whether the number of functions you'd have to change 
for reaching your goal has four, five or six digits.

> vda

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S932284AbYB2NF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbYB2NF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbYB2NFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:05:47 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:43274 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbYB2NFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:05:46 -0500
Date: Fri, 29 Feb 2008 15:04:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080229130426.GB22335@cs181133002.pp.htv.fi>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080216000943.GD31474@flint.arm.linux.org.uk> <20080226145418.59f6f35f.sfr@canb.auug.org.au> <20080229234551.d8023f5c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080229234551.d8023f5c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 11:45:51PM +1100, Stephen Rothwell wrote:
> Hi Russell,
> 
> On Tue, 26 Feb 2008 14:54:18 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Sat, 16 Feb 2008 00:09:43 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > >
> > > As mentioned elsewhere, what we need for ARM is to extend the kautobuild
> > > infrastructure (see armlinux.simtec.co.uk) so that we can have more trees
> > > at least compile tested regularly - but that requires the folk there to
> > > have additional compute power (which isn't going to happen unless folk
> > > stamp up some machines _or_ funding).
> > 
> > I now have an arm cross compiler (gcc-4.0.2-glibc-2.3.6
> > arm-unknown-linux-gnu).  (See the results page at
> > http://kisskb.ellerman.id.au/kisskb/branch/9/ - I must get a better
> > name/place :-(.)  Is this sufficient to help you out?  What configs would
> > be useful to build (as Andrew said, they don't take very long each).
> > 
> > I really want as many subsystems as possible in the linux-next tree in an
> > attempt to avoid some of the merge/conflict problems we have had in the
> > past.  What can we do to help?
> 
> OK, I tried this out:  I built all 75 arm defconfigs with the cross
> compiler above (the resulting log file is at
> http://ozlabs.org/~sfr/armall.log.bz2). 17 failed (I don't know why - I
> didn't even really look).

2 errors are expected (long-standing breakages).

14 failures are due to your ancient gcc 4.0.2 not supporting -mabi=aapcs-linux:
/scratch/sfr/next/scripts/mod/empty.c:1: error: invalid ABI option: -mabi=aapcs-linux

Another one is an internal error in your ancient compiler:
/scratch/sfr/next/arch/arm/common/it8152.c:148: internal compiler error: in trunc_int_for_mode, at explow.c:53

Can you build a cross compiler using gcc 4.2.3 from ftp.gnu.org instead?
That one serves me perfectly for my cross-compile tests.

>...
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


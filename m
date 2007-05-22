Return-Path: <linux-kernel-owner+w=401wt.eu-S1765786AbXEVQUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765786AbXEVQUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbXEVQUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:20:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41833 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757448AbXEVQUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:20:03 -0400
Date: Tue, 22 May 2007 18:19:51 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
Message-ID: <20070522161951.GC2098@stusta.de>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain> <20070522135927.GA2098@stusta.de> <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 10:04:16AM -0400, Robert P. J. Day wrote:
> On Tue, 22 May 2007, Adrian Bunk wrote:
> 
> > On Tue, May 22, 2007 at 09:09:22AM -0400, Robert P. J. Day wrote:
> > >
> > >   given that:
> > >
> > > $ grep -r "define.*NORET_TYPE" *
> > > include/linux/ext4_fs.h:# define NORET_TYPE    /**/
> > > include/linux/linkage.h:#define NORET_TYPE    /**/
> > > include/linux/ext3_fs.h:# define NORET_TYPE    /**/
> > > $
> > >
> > > is there any obvious value to the 30 or so uses of that macro
> > > sprinkled throughout the tree?
> >
> > I can be mistaken, but it seems the uses should be replaced with your
> > __noreturn
> 
> no, i think you're thinking of the alternative ATTRIB_NORET macro.
> as you can read in my previous post, NORET_TYPE used to resolve to
> "__volatile__" for very old gcc.  so i think it's legitimately dead
> and can be ripped out.

No doubt that it could be removed because it doesn't have any effect.

But locking at the usages, it seems to have been used when people 
thought it was what __noreturn now is, so replacing NORET_TYPE with 
__noreturn might be a small optimization (but every NORET_TYPE should 
be checked that it's actually correct).

> rday

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


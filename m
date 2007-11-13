Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbXKMLki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbXKMLki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbXKMLkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:40:22 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38359 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756062AbXKMLkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:40:20 -0500
Date: Tue, 13 Nov 2007 12:39:57 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] add -fno-tree-scev-cprop to KBUILD_CFLAGS
Message-ID: <20071113113957.GB4250@stusta.de>
References: <20071111064829.GG21669@stusta.de> <20071112165843.GF5451@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071112165843.GF5451@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 11:58:43AM -0500, Jakub Jelinek wrote:
> On Sun, Nov 11, 2007 at 07:48:29AM +0100, Adrian Bunk wrote:
> > The gcc from svn that will become gcc 4.3 generates libgcc calls in 
> > cases like the following (on 32bit architectures):
> > 
> > <--  snip  -->
> > 
> > static inline void timespec_add_ns(struct timespec *a, u64 ns)
> > {
> > ...
> >         while(ns >= NSEC_PER_SEC) {
> >                 ns -= NSEC_PER_SEC;
> >                 a->tv_sec++;
> >         }
> > ...
> > 
> > <--  snip  -->
> 
> Blindly using -fno-tree-scev-cprop just to get rid of one case where
> this turns out to be a pessimization when kernel knows ns is usually very
> small is IMHO a wrong thing, you'd lose many cases where this optimization
> can actually improve performance.

It's not about performance, it's about a build error.

> Instead, for this exact case just
> add an optimization barrier to avoid gcc doing this.
> Adding asm ("" : "=r" (ns) : "0" (ns)); (or hide it in some macro) into the
> loop will do the job just fine.

The problem is that this is very fragile - imagine what might happen 
when a frequently used struct member gets changed from int to u64.

After all, when looking at current practice, the kernel will support 
being built with gcc 4.3 until 2013 or 2014.

> 	Jakub

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


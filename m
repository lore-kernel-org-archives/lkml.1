Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYBDVzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYBDVzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYBDVy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:54:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:17294 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbYBDVy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:54:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wUw247W37XJSUDY2XwtVupHhwQO5Np4WPOfq0YUBhaic5k/l+xZ9eccf7ySC4xN437M3fWUbUFQFyBywnKk5GFUIk/sQ5CaRldku6bBf8IpP2azUG6rkDnrLwJy6V9uZHs21Wwb01ZKxZ3+/E52t6oBbc0AYQ4XKdjGJPiUlz9M=
Message-ID: <15577be70802041354s23e5b289w56f724dfdf8c3242@mail.gmail.com>
Date: Mon, 4 Feb 2008 22:54:54 +0100
From: "Abel Bernabeu" <abel.bernabeu@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: brk randomization breaks columns
In-Reply-To: <20080204195251.GB4915@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080204122837.GA1647@elf.ucw.cz> <20080204130156.GA8730@elte.hu>
	 <Pine.LNX.4.64.0802041528470.30955@jikos.suse.cz>
	 <Pine.LNX.4.64.0802041635000.30955@jikos.suse.cz>
	 <15577be70802041016m97cddbfk43b9073408bcbce9@mail.gmail.com>
	 <15577be70802041029o2975ba6do34589bbdc81d1652@mail.gmail.com>
	 <20080204195251.GB4915@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/4, Pavel Machek <pavel@ucw.cz>:
> > >
> > > > I still don't seem to fully understand what is happening here --
> > > > aparently this is triggerable only with old programs linked against
> > > > libc.so.5, and I am not able to trigger it with my trivial program when
> > > > I link it against old libc.so.5, which just basically does brk() and
> > > > checks whether /proc/<pid>/maps are OK. Seems to me that (at least
> > > > certain versions) of libc.so.5 (wrongly) assume that end of the bss is
> > > > the start of the heap, but I will try to investigate it more.
> >
> > I think I am getting the some problem with brand new binaries produced
> > by myself :(
> >
> > Look at this report I posted days ago:
> >
> > http://marc.info/?l=linux-kernel&m=120169141603789&w=2
>
> Your crash is in kernel, no? Anyway, I can workaround mine by
> disabling randomization...

Yes, my crash happens at kernel space, but is due to the randomized
params passed to set_brk (the same thing that makes your game crash
later at runtime).

I did not understand why my kernel was crashing before reading your
comments, but now I think is all happening because of the brk
randomization. Sorry, I will not be able to try disabling
randomization until tomorrow at office in order to confirm you this.

I am trying to figure out what is relation the brk randomization
feature and my crash... but makes sense to me now, trying to find it.

Yours, Abel.

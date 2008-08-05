Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbYHERW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbYHERW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYHERWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:22:14 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:28619 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753185AbYHERWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:22:13 -0400
Date: Wed, 6 Aug 2008 02:21:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: jmerkey@wolfmountaingroup.com
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080805172115.GA29645@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	jmerkey@wolfmountaingroup.com,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <Pine.LNX.4.64.0808051140150.6309@anakin> <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <44919.166.70.238.45.1217949560.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44919.166.70.238.45.1217949560.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 09:19:20AM -0600, jmerkey@wolfmountaingroup.com wrote:
> > On Wednesday 06 August 2008 01:02, jmerkey@wolfmountaingroup.com wrote:
> >> No I was not, but I am now.  At any rate, I removed the Microsoft-isms
> >> from the code.  I can cut yet another patch for git6, but git5 was there
> >> -- GPL2 and all.  How about putting in into the kernel guys -- :-)
> >
> > Seriously? Because it doesn't seem to have had enough peer review,
> > it hasn't had widespread testing in somewhere like linux-next or
> > -mm, and we already have kgdb so you have to also explain why you
> > can't improve kgdb in the areas it trails mdb.
> 
> If you go back to LKML from 2000, this debugger has been around for 10
> years.  I agree not in the hands of the public, but its very mature
> in comparison to kdb or kgdb.
> 
That's great, except kgdb has existed in the kernel for various
architectures well before that as well. ppc32's stub dates back to 1998,
sh had it since 2001, mips around the same time, etc, etc. While the
current rework and tidying of the stubs is something new, kgdb itself is
not.

> > But the ideal outcome would be if you could contribute patches to
> > kgdb to the point where it is as good as mdb. It is already in the
> > tree and supported by a handful of architectures... any chance of
> > that? (I don't know kernel debugger code, so I ask as an interested
> > user)
> 
> I plan to work on kdb and yes, there is a version of this that runs
> as an alternate debugger of kdb - you can even switch back and forth
> between them - but that misses the point as well.
> 
kgdb and kdb are totally different things, kgdb is what is generally
available and worth improving in-kernel.

While it's certainly good to have options, having multiple in-kernel
debuggers is not going to help matters for the vast majority of users. I
agree with Nick, it would be nice to see what we have in-kernel being
extended and worked on by more people, especially those with a background
in these things.

On the other hand, it seems like there's sufficient interest in your
project out-of-tree, so there's not really much point in merging it if
you're content with the interface as it exists today and it continues to
work for your users.

One of the things we can do however is try to provide cleaner
abstractions for the various debuggers to tie in to, so we don't end up
with each debugger piling on its own set of ifdefs in all of the same
places (int3 handling comes to mind, which you could already do more
cleanly through the die chain today). Perhaps it would be more useful to
see what sort of hooks mdb wants in the architecture and core code, how
those overlap with kgdb, and how we might extend kgdb in areas where mdb
is more feature complete.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbXHUK3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbXHUK3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXHUK3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:29:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:42225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbXHUK3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:29:40 -0400
Date: Tue, 21 Aug 2007 13:23:30 +0200
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt issue
Message-ID: <20070821112330.GD32640@bingen.suse.de>
References: <20070809241.425881000@suse.de> <20070809124132.C794A14F3B@wotan.suse.de> <46C637B7.30200@goop.org> <1187574628.19435.29.camel@localhost.localdomain> <20070820020732.GA3672@sequoia.sous-sol.org> <46C9317C.2080509@goop.org> <5d6222a80708210030w26294b0dq4bd1977fcb3bc6f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80708210030w26294b0dq4bd1977fcb3bc6f4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 04:30:10AM -0300, Glauber de Oliveira Costa wrote:
> On 8/20/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > Chris Wright wrote:
> > > That did get backed out (at least the part that broke paravirt patching)
> > > in 602033ed5907a59ce86f709082a35be047743a86.  Linus' tree should be
> > > working fine right now with d34fda4a84c18402640a1a2342d6e6d9829e6db7
> > > committed, and can be further refined with the patch below that's just
> > > waiting on some further testing.
> > >
> >
> > I don't think this is necessary.  It isn't worth complicating the
> > interface to avoid the memcpy.
> >
> >     J
> Damn,
> 
> I can't believe I've just lost a night tracking the issue, without
> seeing the discussion here ;-)
> I came out to this very same conclusion, and was about to send a patch
> that fixes it, by doing a memcpy before starting the instruction
> replacement.
> 
> (I wouldn't say anything, as this is solved, but my night have to get
> some value, after all! ;-)
> 
> So I'm with Jeremy. We don't lose too much by putting a memcpy there,
> this code is not exactly critical. It also seems cleaner, and less
> error prone. I have a patch ready here, but I think by this time, you
> guys have too ;-)

x86-64 also has a __inline_memcpy that is guaranteed inlined. It was
originally for such cases when memcpy didn't work. Could be added to i386
too if there is need

-Andi

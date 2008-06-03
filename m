Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbYFCRRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbYFCRRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYFCRRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:17:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41526 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYFCRRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:17:12 -0400
Date: Tue, 3 Jun 2008 10:05:15 +0200
From: Pavel Machek <pavel@suse.cz>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mtk.manpages@gmail.com,
       Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-ID: <20080603080515.GD27918@elf.ucw.cz>
References: <20080530102619.GA2468@elf.ucw.cz> <Pine.LNX.4.64.0805301451020.19914@blonde.site> <20080530204307.GA4978@ucw.cz> <Pine.LNX.4.64.0805311925190.27293@blonde.site> <20080531173950.c4f04028.akpm@linux-foundation.org> <Pine.LNX.4.64.0806010752510.24919@blonde.site> <20080601011501.199af80c.akpm@linux-foundation.org> <20080601114008.GC16843@elf.ucw.cz> <cfd18e0f0806030101x40e18f9do5e58784695cdaa46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0806030101x40e18f9do5e58784695cdaa46@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-06-03 10:01:22, Michael Kerrisk wrote:
> On Sun, Jun 1, 2008 at 1:40 PM, Pavel Machek <pavel@suse.cz> wrote:
> > Hi!
> >
> >> > > > All I can say so far is that I find the same as you do:
> >> > > > SYNC_FILE_RANGE_WRITE (after writing) takes a significant amount of time,
> >> > > > more than half as long as when you add in SYNC_FILE_RANGE_WAIT_AFTER too.
> >> > > >
> >> > > > Which make the sync_file_range call pretty pointless: your usage seems
> >> > > > perfectly reasonable to me, but somehow we've broken its behaviour.
> >> > > > I'll be investigating ...
> >> > >
> >> > > It will block on disk queue fullness - sysrq-W will tell.
> >> >
> >> > Ah, thank you.  What a disappointment, though it's understandable.
> >> > Doesn't that very severely limit the usefulness of the system call?
> >>
> >> A bit.  The request queue size is runtime tunable though.
> >
> > Which /sys is that? What happens if I set the queue size to pretty
> > much infinity, will memory management die horribly?
> >
> >> I expect major users of this system call will be applications which do
> >> small-sized overwrites into large files, mainly databases.  That is,
> >> once the application developers discover its existence.  I'm still
> >> getting expressions of wonder from people who I tell about the
> >> five-year-old fadvise().
> >
> > Hey, you have one user now, its called s2disk. But for this call to be
> > useful, we'd need asynchronous variant... is there such thing?
> >
> > Okay, I can fork and do the call from another process, but...
> >
> >> > I admit the flag isn't called SYNC_FILE_RANGE_WRITE_WITHOUT_WAITING,
> >> > but I don't suppose Pavel and I are the only ones misled by it.
> >>
> >> Yup, this caveat/restriction should be in the manpage.
> >
> > Michael, this is something for you I guess?
> 
> Pavel,
> 
> Just to confirm: you are meaning that the sentence
> 
>     Notice that even this this may and will block if you attempt
>     to write more than request queue size.
> 
> should be added to the man page under the description of
> SYNC_FILE_RANGE_WRITE, right?

Yes.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

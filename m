Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbYCZK1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbYCZK1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYCZK1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:27:13 -0400
Received: from lazybastard.de ([212.112.238.170]:46152 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYCZK1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:27:13 -0400
Date: Wed, 26 Mar 2008 11:26:54 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Message-ID: <20080326102654.GB22847@logfs.org>
References: <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325160734.GA14583@logfs.org> <20080326095249.GD22584@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080326095249.GD22584@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 March 2008 09:52:49 +0000, Andy Whitcroft wrote:
> On Tue, Mar 25, 2008 at 05:07:35PM +0100, Jörn Engel wrote:
> > 
> > (foo*) should be (foo *)
> > 	What does that extra space gain us?
> 
> It really gains us nothing, however that is not really the point.
> The point is that consistancy is good, with the space is the more normal
> 'C' usage, without for 'C++'; something to do with the implication that
> (foo *) is a pointer to a foo (separate things), and (foo*) is a thing
> of type pointer to foo (one thing) which is more object oriented.
> 
> The "norm" is with and so it makes sense to maintain it that way.  A lot
> of the layout and style choises are arbitrary, and disliked by many of us,
> but we follow the style to maintain that common feel.

Then I'll happily ignore it.  Not having the space gains me one column.
It is absolutely minimal, sure.  But when the alternative is based on
pure whim...

> > ERROR: trailing statements should be on next line
> > #5000: FILE: fs/logfs/readwrite.c:203:
> > +       } else while (unlikely(TestSetPageLocked(page))) {
> > 
> > We have an explicit exception for "else if".  "else while" makes imo
> > just as much (or as little) sense.
> 
> "else if" is at least creating an additional arm of the same control
> structure.  else while is mixing two different paradigms.

Fairly weak grounds to argue on.  Not that mine are much stronger, I
just default to less (shorter, fewer indentations, etc.) when lacking a
reason to use more (characters, lines, indentations, etc.).

> > ERROR: need space after that ',' (ctx:VxV)
> > #5801: FILE: fs/logfs/readwrite.c:1004:
> > +               ret = logfs_segment_read(inode, ipage, this_wc->ofs, bix,level);
> >                                       
> > One of those examples where a missing space is the lesser of two or
> > three evils.
> 
> Because to add the space would mean breaking the line to avoid exceeding
> 80 characters?

Or breaking the line.  Either of those choices sucks.  Well, breaking
the line is often the lesser of those evils, but in this particular
function it looks worse to me - and I have to stare at it often enough
to care.

The best strategy usually is to rethink the code and reduce the
indentation, number of arguments or length of identifiers.  I just don't
see a good way of doing that without resorting to
		ret = logfs_segment_read(i, p, w->o, b, l);

Probably nothing checkpatch should worry about.  Although I would have
been happy to have finer-grained options to enable/disable particular
warnings on the command line.  Right now I commented out several lines
in checkpatch.pl.

Jörn

-- 
Joern's library part 7:
http://www.usenix.org/publications/library/proceedings/neworl/full_papers/mckusick.a

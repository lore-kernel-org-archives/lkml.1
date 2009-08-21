Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZHVLrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZHVLrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 07:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbZHVLrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 07:47:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39865 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbZHVLq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 07:46:59 -0400
Date: Fri, 21 Aug 2009 16:02:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, David Wagner <daw-news@cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: Security: information leaks in /proc enable keystroke recovery
Message-ID: <20090821140241.GB1337@ucw.cz>
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu> <20090816003326.GC7554@mit.edu> <h67kou$ahr$1@taverner.cs.berkeley.edu> <20090816013346.GA17958@mit.edu> <h6a8da$40j$1@taverner.cs.berkeley.edu> <20090817022215.GI17958@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817022215.GI17958@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > (b) Keep /proc/$pid/wchan.  We suspect that it's possible this might
> > be usable for keystroke recovery, but we're not sure, and we do know
> > that blocking this entirely might annoy administrators, so rather than
> > blocking access entirely, apply a more lenient policy.  If the user
> > is not the owner of the process and is not root, allow up to about 10
> > accesses to /proc/$pid/wchan per, say, 10 minutes; if a user makes more
> > than 10 accesses per 10-minute period, insert random delays on the order
> > of a few hundred milliseconds into every access to /proc/$pid/wchan.
> > 
> > Notes: It is critical to do this by user, rather than by process;
> > otherwise a malicious user can fork a bazillion processes, each of which
> > reads /proc/$pid/wchan a constant number of times.  The "few hundred
> > milliseconds" comes from the fact that, for touch typists, typing two
> > keys with alternating hands typically takes something like 0-150ms,
> 
> I was going to suggest instead of doing it by user or by process,
> doing it globally; that is, *any* non-root process tries to access a
> particular task's wchan /proc file more than X accesses per Y minutes,
> we start inserting random delays.  Note that the "top" program by
> default will refresh the screen once every 3 seconds, so allowing at
> least 20 accesses per minute would be necessary to prevent "top" from
> getting hit by a pretty massive slowdown.
> 
> That should be fine, I think; even if someone were to query wchan once
> a second, it doesn't seem likely that would be enough to be able to
> carry out a keystroke timing attack.

It will still be complex accounting :-(. Is really wchan so useful?

> In addition, if you know that the user is entering a password at that
> point in time, simply looking to see whether the process is in state
> 'R' or 'S' might be enough to know when the keystrokes are being
> entered.  I might be willing to put that in the category, "We suspect
> that it's possible this might be usable for keystroke recovery, but
> we're not sure" --- but it would be a pretty strong suspicion.  As far
> as whether you could use WCHAN for keystroke recovery, I'd call that a
> near-certainty.
> 
> There are other timing channels I'd be wary of as well; for example,
> simply using stat on the pseudo-tty will record the last access time
> to a very high degree of accuracy:

/proc/interrupts ? various interfaces powertop uses?

I did not have chance to read the paper yet, but... does not ssh have
bad problem in that case?

								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

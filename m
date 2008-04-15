Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbYDOUGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbYDOUGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762119AbYDOUGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:06:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43312 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761977AbYDOUGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:06:15 -0400
Date: Tue, 15 Apr 2008 22:06:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jan Kara <jack@suse.cz>, Bodo Eggert <7eggert@gmx.de>,
       Diego Calleja <diegocg@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080415200647.GF4994@elf.ucw.cz>
References: <20080414165354.GF15824@duck.suse.cz> <20080414170613.GI7385@csclub.uwaterloo.ca> <20080414190308.GJ15824@duck.suse.cz> <20080414192928.GM7385@csclub.uwaterloo.ca> <20080415085740.GA7603@atrey.karlin.mff.cuni.cz> <20080415153221.GD7387@csclub.uwaterloo.ca> <20080415173430.GB4994@elf.ucw.cz> <20080415182453.GR7385@csclub.uwaterloo.ca> <20080415191238.GC4994@elf.ucw.cz> <20080415194922.GT7385@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415194922.GT7385@csclub.uwaterloo.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> So other than that, is there any case in which lseek being not atomic
> can cause an application to break if it wasn't already broken (due to
> having a race condition by trying to do 2 or more seeks on the same file
> handle at the same time)?  If not, I think adding any kind of locking to
> seek in the kernel (which would I think have to cause a slight slow
> down) is a bad move.  But hey that's just my opinion. :)  I won't be
> upset either way.

Of course I can write an application that will be broken by this, and
was not broken before. It will be slightly nasty code. Come on, you
can do this too ;-).


> > I'm not saying this kernel bug is likely to hit in practice. It is
> > still a kernel bug.
> > 
> > Is the slowdown of lseek worth getting rid of this minor bug? Not
> > sure, probably yes.
> 
> I think a slow down is the worse choice.  Adding a note to the
> documentation saying that "By the way, on 32bit systems the seek call is
> not atomic for 64bit file offsets, so if you happen to issue two at

That would be very wrong addition to documentation. If you really
wanted to do something like this, you would probably want to say
something like

"Doing concurrent seeks on one file is undefined. Kernel may end up
with seeking to some other place."

Unfortunately, you'd have to get this addition into POSIX standard...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

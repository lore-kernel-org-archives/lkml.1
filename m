Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbYDORdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbYDORdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYDORdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:33:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37142 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYDORdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:33:45 -0400
Date: Tue, 15 Apr 2008 19:34:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jan Kara <jack@suse.cz>, Bodo Eggert <7eggert@gmx.de>,
       Diego Calleja <diegocg@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080415173430.GB4994@elf.ucw.cz>
References: <E1JkIJ0-0000tG-LV@be1.7eggert.dyndns.org> <20080411135544.GG2160@csclub.uwaterloo.ca> <20080414162031.GD15824@duck.suse.cz> <20080414162202.GB7387@csclub.uwaterloo.ca> <20080414165354.GF15824@duck.suse.cz> <20080414170613.GI7385@csclub.uwaterloo.ca> <20080414190308.GJ15824@duck.suse.cz> <20080414192928.GM7385@csclub.uwaterloo.ca> <20080415085740.GA7603@atrey.karlin.mff.cuni.cz> <20080415153221.GD7387@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415153221.GD7387@csclub.uwaterloo.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Not if you tried to do checking from ptrace monitor.
> > 
> > And heck, yes, it is very confusing to see
> > 
> > seek(somewhere)
> > write()
> > 
> > ond ptrace and write going somewhere else.
> 
> Yes bugs are confusing.  An application can't do this on demand so you
> can't write code that relies on the effect between threads.  So it would
> only be a bug, not a bizare feature (that wouldn't even work on 64bit
> machines).

Yes, kernel bugs are confusing ;-).

The "application" could be malware trying to confuse debugger, for
example.

The "application" could be something you are trying to debug.

I did brief reading on lseek man pages, and it does not mention
"kernel may seek to random place if you attempt to seek  from two
threads at the same time". So this is a kernel or manpages bug.

Maybe you can take a look at POSIX if it permits this behaviour? 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

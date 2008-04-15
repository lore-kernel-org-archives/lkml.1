Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbYDOI5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbYDOI5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbYDOI5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:57:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34058 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbYDOI5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:57:42 -0400
Date: Tue, 15 Apr 2008 10:57:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jan Kara <jack@suse.cz>, Bodo Eggert <7eggert@gmx.de>,
       Diego Calleja <diegocg@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080415085740.GA7603@atrey.karlin.mff.cuni.cz>
References: <ah66A-4Nk-7@gated-at.bofh.it> <ah7vN-7Wz-9@gated-at.bofh.it> <E1JkIJ0-0000tG-LV@be1.7eggert.dyndns.org> <20080411135544.GG2160@csclub.uwaterloo.ca> <20080414162031.GD15824@duck.suse.cz> <20080414162202.GB7387@csclub.uwaterloo.ca> <20080414165354.GF15824@duck.suse.cz> <20080414170613.GI7385@csclub.uwaterloo.ca> <20080414190308.GJ15824@duck.suse.cz> <20080414192928.GM7385@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414192928.GM7385@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 14, 2008 at 09:03:09PM +0200, Jan Kara wrote:
> >   Why would it be doing locking? If some nasty user runs the process, he
> > *wants* his two threads to race as much as possible and trigger the race.
> > And then use corrupted f_pos.
> 
> Why would you want to?  You can already set the filepointer explicitly
> to any value you want if you have the filehandle.
> 
> If you had a file with some security checks for whether the user could
> read from it implemented based on locations then you would check it when
> you read/write not when you seek, since after all you could just keep
> reading until you get to the desired position.

Not if you tried to do checking from ptrace monitor.

And heck, yes, it is very confusing to see

seek(somewhere)
write()

ond ptrace and write going somewhere else.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

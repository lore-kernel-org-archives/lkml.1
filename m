Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbYDOSZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbYDOSZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYDOSYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:24:54 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35144 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbYDOSYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:24:53 -0400
Date: Tue, 15 Apr 2008 14:24:53 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Kara <jack@suse.cz>, Bodo Eggert <7eggert@gmx.de>,
       Diego Calleja <diegocg@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080415182453.GR7385@csclub.uwaterloo.ca>
References: <20080411135544.GG2160@csclub.uwaterloo.ca> <20080414162031.GD15824@duck.suse.cz> <20080414162202.GB7387@csclub.uwaterloo.ca> <20080414165354.GF15824@duck.suse.cz> <20080414170613.GI7385@csclub.uwaterloo.ca> <20080414190308.GJ15824@duck.suse.cz> <20080414192928.GM7385@csclub.uwaterloo.ca> <20080415085740.GA7603@atrey.karlin.mff.cuni.cz> <20080415153221.GD7387@csclub.uwaterloo.ca> <20080415173430.GB4994@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415173430.GB4994@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 07:34:30PM +0200, Pavel Machek wrote:
> Yes, kernel bugs are confusing ;-).

I only see an application bug so far.

> The "application" could be malware trying to confuse debugger, for
> example.

If you can't do it on demand (which I can't see any way to do) then I
don't think malware can take advantage of it.

> The "application" could be something you are trying to debug.

True, but even without this behaviour doing seeks and read/writes from
multiple threads without locking will already show plenty of problems
even if you somehow manage to hit this issue, and not only that you have
to have threads writing to different 4GB aligned chunks of the file to
cause a problem, since otherwise they would all be setting the top bits
the same.  I would hope anyone doing multithreaded work on a file that
big would like to avoid the locking issue by using pread and pwrite
instead in which case there is no problem either.

> I did brief reading on lseek man pages, and it does not mention
> "kernel may seek to random place if you attempt to seek  from two
> threads at the same time". So this is a kernel or manpages bug.

Does it say anything about what happens if you try to seek from two
places at once?

> Maybe you can take a look at POSIX if it permits this behaviour? 

The parts I can find for posix don't say one way or the other.

-- 
Len Sorensen

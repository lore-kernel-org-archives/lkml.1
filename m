Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbYDOUaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbYDOUaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbYDOU3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:29:33 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:52882 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932290AbYDOU3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:29:31 -0400
Date: Tue, 15 Apr 2008 16:29:31 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Kara <jack@suse.cz>, Bodo Eggert <7eggert@gmx.de>,
       Diego Calleja <diegocg@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080415202931.GU7385@csclub.uwaterloo.ca>
References: <20080414170613.GI7385@csclub.uwaterloo.ca> <20080414190308.GJ15824@duck.suse.cz> <20080414192928.GM7385@csclub.uwaterloo.ca> <20080415085740.GA7603@atrey.karlin.mff.cuni.cz> <20080415153221.GD7387@csclub.uwaterloo.ca> <20080415173430.GB4994@elf.ucw.cz> <20080415182453.GR7385@csclub.uwaterloo.ca> <20080415191238.GC4994@elf.ucw.cz> <20080415194922.GT7385@csclub.uwaterloo.ca> <20080415200647.GF4994@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415200647.GF4994@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 10:06:47PM +0200, Pavel Machek wrote:
> Of course I can write an application that will be broken by this, and
> was not broken before. It will be slightly nasty code. Come on, you
> can do this too ;-).

Well it would take seriously hard work to make a program that would work
correctly if it was atomic and would break if it isn't.  Certainly a
normal program that just tries to seek and read/write should never have
any issue.

> That would be very wrong addition to documentation. If you really
> wanted to do something like this, you would probably want to say
> something like
> 
> "Doing concurrent seeks on one file is undefined. Kernel may end up
> with seeking to some other place."

Well perhaps that is a lot simpler.

> Unfortunately, you'd have to get this addition into POSIX standard...

Well I do see something in a PDF on posix I found that says all posix
functions (at least in POXIS.1 which I think might be an old name for
it) are thread safe unless stated otherwise, so since lseek doesn't
state otherwise I suppose it better be completely thread safe in all
cases.  It seems a bit stupid given any program that wants to work
reliably has to do its own locking already, so why waste time on it in
the kernel.  Any way the kernel could know how many copies of the
filehandle exist (yeah right, of course not) to ensure that it only has
to lock if there is multiple accesses going on?  Darn.

Those stupid standards documents. :)

-- 
Len Sorensen

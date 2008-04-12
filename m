Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYDLIrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYDLIrs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 04:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759794AbYDLIrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 04:47:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46609 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758963AbYDLIr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:47:28 -0400
Date: Sat, 12 Apr 2008 10:48:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Bodo Eggert <7eggert@gmx.de>,
       Diego Calleja <diegocg@gmail.com>, Jan Kara <jack@suse.cz>,
       Jiri Kosina <jkosina@suse.cz>, linux-fsdevel@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080412084808.GA28339@elf.ucw.cz>
References: <20080411135544.GG2160@csclub.uwaterloo.ca> <OF861D7F24.6F60C82D-ON88257428.005C1DA4-88257428.005D5D80@us.ibm.com> <20080411171534.GO2158@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411171534.GO2158@csclub.uwaterloo.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >So if you write multithreaded code and don't understand what locking
> > >around shared resources is for, then your application might break.
> > 
> > I think I know what locking around shared resources is for, which is why 
> > I'm surprised the kernel doesn't do it.
> > 
> > Is it normal for a kernel resource not to be thread-safe (i.e. you don't 
> > get advertised/sensible results if two threads access it at the same 
> > time)?
> 
> If two threads are changing one filehandle at the same time, then the
> program is broken.  I can't see how the kernel making updates to 64bit
> filehandles "atomic" helps.  You could still seek in one thread, then
> seek in another and then start the write in the first and get a wrong
> result.  Changes to a shared filehandle of any kind requires locking to
> work reliably, so additional slow downs and locking in the kernel won't
> fix anything.

Well, app may be broken, or it may be trying to confuse you.

If you were stracing app, it seeked at 1GB and at 7GB, then did
read(), you'd be certainly very surprised if it did read secret data
at 3GB, right?

And ptrace monitors do exist.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

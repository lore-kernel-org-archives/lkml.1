Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbYDPIVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbYDPIVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 04:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYDPIUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 04:20:52 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:45596 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYDPIUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 04:20:50 -0400
Subject: Re: file offset corruption on 32-bit machines?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pavel Machek <pavel@ucw.cz>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Jan Kara <jack@suse.cz>,
       Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080416081523.GB5105@elf.ucw.cz>
References: <20080414190308.GJ15824@duck.suse.cz>
	 <20080414192928.GM7385@csclub.uwaterloo.ca>
	 <20080415085740.GA7603@atrey.karlin.mff.cuni.cz>
	 <20080415153221.GD7387@csclub.uwaterloo.ca>
	 <20080415173430.GB4994@elf.ucw.cz>
	 <20080415182453.GR7385@csclub.uwaterloo.ca>
	 <20080415191238.GC4994@elf.ucw.cz>
	 <20080415194922.GT7385@csclub.uwaterloo.ca>
	 <20080415200647.GF4994@elf.ucw.cz> <1208291336.7053.16.camel@lappy>
	 <20080416081523.GB5105@elf.ucw.cz>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 10:20:28 +0200
Message-Id: <1208334028.6395.65.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-16 at 10:15 +0200, Pavel Machek wrote:
> On Tue 2008-04-15 22:28:55, Peter Zijlstra wrote:
> > On Tue, 2008-04-15 at 22:06 +0200, Pavel Machek wrote:
> > 
> > > > > I'm not saying this kernel bug is likely to hit in practice. It is
> > > > > still a kernel bug.
> > > > > 
> > > > > Is the slowdown of lseek worth getting rid of this minor bug? Not
> > > > > sure, probably yes.
> > > > 
> > > > I think a slow down is the worse choice.  Adding a note to the
> > > > documentation saying that "By the way, on 32bit systems the seek call is
> > > > not atomic for 64bit file offsets, so if you happen to issue two at
> > > 
> > > That would be very wrong addition to documentation. If you really
> > > wanted to do something like this, you would probably want to say
> > > something like
> > > 
> > > "Doing concurrent seeks on one file is undefined. Kernel may end up
> > > with seeking to some other place."
> > > 
> > > Unfortunately, you'd have to get this addition into POSIX standard...
> > 
> > Is not treating the point not similar to undefined? And undefined
> > semantics cover pretty much anything, including the current behaviour.
> > 
> > FWIW I really think this issue is a non-issue; one cannot expect sane
> > behaviour of unsynchronized usage of a shared resource.
> 
> Why not? Kernel syscalls are traditionally atomic, and Lennard seems
> to have found sentence in POSIX that says so.

Ah, ok missed that part.


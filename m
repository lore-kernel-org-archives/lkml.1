Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbXLZVMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbXLZVMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 16:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXLZVLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 16:11:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50546 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751401AbXLZVLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 16:11:53 -0500
Date: Wed, 26 Dec 2007 22:11:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ritesh Raj Sarraf <rrs@researchut.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Suspend-devel] Fwd: Kernel Oops with 2.6.23
Message-ID: <20071226211137.GI8094@elf.ucw.cz>
References: <200711300103.38658.rrs@researchut.com> <200712030601.33212.rrs@researchut.com> <20071203215105.GC8704@elf.ucw.cz> <200712172146.01667.rrs@researchut.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712172146.01667.rrs@researchut.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-12-17 21:45:54, Ritesh Raj Sarraf wrote:
> On Tuesday 04 December 2007, Pavel Machek wrote:
> > On Mon 2007-12-03 06:01:26, Ritesh Raj Sarraf wrote:
> > > On Sunday 02 December 2007, Pavel Machek wrote:
> > > > killall -9 pulseaudio. If pulseaudio is not dead within 60 seconds,
> > > > you hit a kernel bug. If it needs suspend to be reproduced, you
> > > > probably have a suspend bug.
> > >
> > > Hi Pavel,
> > >
> > > Something similar to this are multiple cases where the kernel is not able
> > > to kill a process at all.
> > >
> > > A good example is an application pumping IO to a multipathed device. When
> > > all the paths to the multipathed devices go down, and you'd like to kill
> > > the process, there is no way left to do it. In fact, a reboot also
> > > doesn't work in such cases. Reboot gets hung in midway trying to kill the
> > > process. The user is left to do a hard reset of the machine.
> > >
> > > In situations like these, the processes go into D state.
> > >
> > > Here's what the manpage of ps says:
> > >
> > > PROCESS STATE CODES
> > >        Here are the different values that the s, stat and state output
> > > specifiers (header "STAT" or "S")
> > >        will display to describe the state of a process.
> > >        D    Uninterruptible sleep (usually IO)
> > >
> > > Does it mean that processes in D state are excluded by the kernel from
> > > being killed ? Or is it still a kernel bug ?
> >
> > Still a kernel bug. Processes should not stay in D state for long.
> > 									Pavel
> 
> Hi Pavel,
> 
> Sometime back we discussed about 'D' state processes which are not killed by 
> the kernel by any signal.
> 
> Here's a bugzilla detailing the symptom.
> https://bugzilla.redhat.com/show_bug.cgi?id=419581
> [I/O Processes don't get killed when all the paths to the LUN are down]
> 
> It is still being assumed as working as designed.

This is borderline.

I guess multipath should use new TASK_KILLABLE infrastructure, but I
do not expect RedHat to backport that.

Feel free to implement that yourself, it should be quite easy.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

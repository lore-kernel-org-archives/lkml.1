Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbXCSPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbXCSPIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932419AbXCSPIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:08:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40490 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932325AbXCSPIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:08:20 -0400
Date: Mon, 19 Mar 2007 16:07:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend to RAM fault in VT when resuming
Message-ID: <20070319150753.GC1915@elf.ucw.cz>
References: <45F709F2.80504@canonical.com> <20070313212457.GD12370@elf.ucw.cz> <45F752EF.6030701@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F752EF.6030701@canonical.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-03-13 19:42:07, Tim Gardner wrote:
> Pavel Machek wrote:
> > Hi1
> > 
> >> I've chased one of the 'Suspend to RAM' resume problems to a specific
> >> line in drivers/char/vt.c, see attached 2.6.21-rc3 diff with
> > 
> > Has suspend/resume ever worked on that hardware?
> > 
> >> TRACE_RESUME() instrumentation. The macro scr_writew resolves to '*addr
> >> = val', which appears to be causing the problem. I've verified that the
> >> pointer is not NULL, but don't know if its really valid. Its pretty
> >> tough to tell what is happening, but on a Dell XPS it just hangs. A Dell
> >> Precision blinks the keyboard lights.
> > 
> > It is possible that video is not initialized at that point, and that
> > hardware goes seriously unhappy when you access non-existing vga. Does
> > it resume ok when you completely disable video support? 
> 
> Resume works on the Dell XPS with the Ubuntu Edgy release
> Ubuntu-2.6.17-10.25 (2.6.17 plus a zillion fixes). Ubuntu's git tree is
> rsync://rsync.kernel.org/pub/scm/linux/kernel/git/bcollins/ubuntu-2.6.git.
> Ubuntu-2.6.17-8.21 is the first version where resume works, but there
> are a boatload of changes in ACPI and SW suspend between that and the
> previous tag Ubuntu-2.6.17-7.20. I don't know what made SW suspend work,
> but even knowing that won't tell me what broke it again.
> 
> I've been avoiding the bisect process because it is quite time consuming
> on my slow machine, there is much branch weirdness, and I'm not that
> good with git. I thought if I narrowed the failure down to a small chunk
> of code in 2.6.21-rc3, then the answer might be obvious. No such luck, huh?
> 
> This crash behaves like the video memory space has become unmapped. Is
> that possible?

That seems improbable. It is physical ram, we do not unmap that..

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

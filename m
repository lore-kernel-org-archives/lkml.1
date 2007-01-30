Return-Path: <linux-kernel-owner+w=401wt.eu-S964928AbXA3ADz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928AbXA3ADz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965015AbXA3ADz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:03:55 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55909 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964928AbXA3ADy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:03:54 -0500
Date: Tue, 30 Jan 2007 01:03:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alessandro Di Marco <dmr@gmx.it>
Cc: Vojtech Pavlik <vojtech@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070130000341.GA17483@elf.ucw.cz>
References: <87lkjthdmd.fsf@gmx.it> <20070123184432.GE18662@elf.ucw.cz> <873b61cf1v.fsf@gmx.it> <20070126171536.GB964@elf.ucw.cz> <878xfpoeom.fsf@gmx.it> <20070127174525.GA4787@ucw.cz> <20070127192034.GA17652@suse.cz> <874pqanddd.fsf@gmx.it> <20070129222833.GB17330@elf.ucw.cz> <87odoho3pb.fsf@gmx.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87odoho3pb.fsf@gmx.it>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
>    >    The /proc/bus/input/devices has an extensible structure. You can just
>    >    add an "A:" line (for Activity) instead of adding a new proc file.
>    > 
>    > I know, but IMO there is too much stuff to parse in there. Activity counters
>    > are frequently accessed by daemons, and four or five concurrent daemons are the
>    > norm in a typical X11 linux box...
> 
>    Syscalls are fast enough, and the file is _very_ easy (=> fast) to parse.
> 
>    >    Also, the activity counters should IMO coincide with the event times
>    >    passed through /dev/input/event, and should not be jiffies based.
>    >    Ideally, both should be based on clock_gettime(CLOCK_MONOTONIC).
>    > 
>    > In evdev.c do_gettimeofday() is used. Anyway I just need of a monotonic
>    > counter, so get_jiffies_64() wouldn't be better? It isn't affected by wrapping
>    > issues and it is probably faster than do_gtod().
> 
>    Just use same time source rest of inputs already do...
> 
> OK, but what about the time-warp problem?. To fix it I need to know when the
> system goes to sleep/resumes. In SIN I've solved via the platform driver,
> introducing suspend() resume() callbacks...

input drivers will already have suspend() resume() callbacks... could
you reuse those?

...hmm, I see no easy place where to hook these. You could reuse your
platform device trick, I guess... but maybe there's a better way?

Vojtech, do we have some "global" hooks for input suspend/resume? This
code is global to all the devices, but still needs to know about
suspend/resume...

Or we could create notifier list, where interested parties would be
informed of suspend/resume...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbXA2WmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbXA2WmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933085AbXA2WmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:42:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:40807 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933029AbXA2WmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:42:11 -0500
X-Authenticated: #14842415
From: Alessandro Di Marco <dmr@gmx.it>
To: Pavel Machek <pavel@ucw.cz>
Cc: Vojtech Pavlik <vojtech@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
References: <87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz>
	<87lkjthdmd.fsf@gmx.it> <20070123184432.GE18662@elf.ucw.cz>
	<873b61cf1v.fsf@gmx.it> <20070126171536.GB964@elf.ucw.cz>
	<878xfpoeom.fsf@gmx.it> <20070127174525.GA4787@ucw.cz>
	<20070127192034.GA17652@suse.cz> <874pqanddd.fsf@gmx.it>
	<20070129222833.GB17330@elf.ucw.cz>
Date: Mon, 29 Jan 2007 23:42:08 +0100
In-Reply-To: <20070129222833.GB17330@elf.ucw.cz> (Pavel Machek's message of "Mon\, 29 Jan 2007 23\:28\:33 +0100")
Message-ID: <87odoho3pb.fsf@gmx.it>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

   Hi!

   >    The /proc/bus/input/devices has an extensible structure. You can just
   >    add an "A:" line (for Activity) instead of adding a new proc file.
   > 
   > I know, but IMO there is too much stuff to parse in there. Activity counters
   > are frequently accessed by daemons, and four or five concurrent daemons are the
   > norm in a typical X11 linux box...

   Syscalls are fast enough, and the file is _very_ easy (=> fast) to parse.

   >    Also, the activity counters should IMO coincide with the event times
   >    passed through /dev/input/event, and should not be jiffies based.
   >    Ideally, both should be based on clock_gettime(CLOCK_MONOTONIC).
   > 
   > In evdev.c do_gettimeofday() is used. Anyway I just need of a monotonic
   > counter, so get_jiffies_64() wouldn't be better? It isn't affected by wrapping
   > issues and it is probably faster than do_gtod().

   Just use same time source rest of inputs already do...

OK, but what about the time-warp problem?. To fix it I need to know when the
system goes to sleep/resumes. In SIN I've solved via the platform driver,
introducing suspend() resume() callbacks...

greets,

-- 
Technology is dominated by two types of people: those who understand what they
do not manage, and those who manage what they do not understand. - Putt's Law

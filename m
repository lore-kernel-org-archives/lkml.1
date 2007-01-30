Return-Path: <linux-kernel-owner+w=401wt.eu-S965464AbXA3JmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965464AbXA3JmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 04:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965475AbXA3JmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 04:42:07 -0500
Received: from styx.suse.cz ([82.119.242.94]:53526 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965464AbXA3JmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 04:42:05 -0500
Date: Tue, 30 Jan 2007 10:42:05 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Alessandro Di Marco <dmr@gmx.it>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070130094205.GA2888@suse.cz>
References: <87lkjthdmd.fsf@gmx.it> <20070123184432.GE18662@elf.ucw.cz> <873b61cf1v.fsf@gmx.it> <20070126171536.GB964@elf.ucw.cz> <878xfpoeom.fsf@gmx.it> <20070127174525.GA4787@ucw.cz> <20070127192034.GA17652@suse.cz> <874pqanddd.fsf@gmx.it> <20070129222833.GB17330@elf.ucw.cz> <87odoho3pb.fsf@gmx.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87odoho3pb.fsf@gmx.it>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 11:42:08PM +0100, Alessandro Di Marco wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
>    Hi!
> 
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
 
Well, you just need to make sure that a resume() actually is a visible
event ...

-- 
Vojtech Pavlik
Director SuSE Labs

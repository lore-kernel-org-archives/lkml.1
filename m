Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbXKSNzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbXKSNzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbXKSNz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:55:26 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:55305 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXKSNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:55:25 -0500
Date: Mon, 19 Nov 2007 08:54:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
In-Reply-To: <3efb10970711190455n5e635823t40a320c4b444fa57@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0711190851450.3064@gandalf.stny.rr.com>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
 <Pine.LNX.4.58.0711170840130.4453@gandalf.stny.rr.com>
 <3efb10970711170736u469bbbc5p8c227ca2a12657dd@mail.gmail.com>
 <3efb10970711190455n5e635823t40a320c4b444fa57@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 19 Nov 2007, Remy Bohmer wrote:

> Hello Steven,
>
> > > OK, I wont be able to work on this this weekend, but I'll try to get to it
> > > on Monday.  A better example to show the bug you are looking for is simply
> > > create a mutex and create a thread that grabs that mutex and goes to
> > > sleep. Have your driver read grab that mutex with
> > > mutex_lock_interruptible. And if the signal code is broken with this, then
> > > you definitely got a point that the inerruptible code is broken.
>
> I removed the 'struct semaphore' completely from my driver, using real
> mutexes now instead, replace the signalling semaphores by 'struct
> completion' mechanisms and got rid of the possible race I saw with the
> completions in a different way, and now the problem is completely
> gone!
>
> Posix Signals work properly now (no OOPS anymore), so the problem was
> likely related to the way I used the 'struct semaphore' types, which
> is thus different compared to the non-RT kernel and therefor quite
> confusing.
>
> So, thank you (and Daniel) for pointing me into the right direction.
>
> Now lets get rid of the 'struct semaphore' completely in the kernel :-))

Remy,

Thanks a lot for looking further into this. I'd like to join the fun in
removing the rest of the semaphores in the kernel, but with you, Ingo,
Daniel and Jon going to do that, one more cook will just spoil the stew.

Once we get rid of all the semaphores in the kernel that are being used as
mutexes, then we can change the code in the -rt patch to keep semaphores
default as compat_semaphores.  And any out of tree driver would just need
to be fixed to use mutexes.

Well, read/write semaphores might have to stay special.

Thanks,

-- Steve


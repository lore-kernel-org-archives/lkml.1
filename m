Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbXD2Ixj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbXD2Ixj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbXD2Ixj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:53:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36398 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065AbXD2Ixi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:53:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Back to the future.
Date: Sun, 29 Apr 2007 10:57:47 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704290103.38409.rjw@sisk.pl> <alpine.LFD.0.98.0704281640480.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704281640480.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291057.48747.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 April 2007 01:45, Linus Torvalds wrote:
> 
> On Sun, 29 Apr 2007, Rafael J. Wysocki wrote:
> > 
> > OK, more precisely: fs-related threads should not try to process their queues,
> > etc., after the snapshot is done, because that may cause some fs data to be
> > written at that time and then the fs in question may be corrupted after the
> > restore.  Not all of the I/O in general, fs data.
> 
> But that's not true _either_. That's only true because right now I think 
> we cannot even suspend to a swapfile (I might be wrong). 

You are.
 
> If you have a swapfile on a filesystem, you'd need those fs queues 
> running!

No, I don't.  It's done by bmapping the file and writing directly to the
underlying blockdev.  Otherwise we'd have corrupted filesystems after the
restore.

Swapfiles are handled this way anyway, so we just use the same code.

> > Well, I'm not sure whether or not that still would have been the case if we had
> > stopped to freeze kernel threads for the hibernation/suspend.
> 
> Did you miss the email where Paul pointed out that Mac/PowerPC didn't use 
> to do any of this?

No, I didn't.

> And apparently never had any issues with it?

On one platform with a limited subset of device drivers.

> And probably worked more reliably several years ago than suspend/hibernation 
> does _today_?

I have no problems with the hibernation on my test boxes (six of them), except
for one network driver that doesn't bother to define a .suspend() callback.

There are problems with the suspend (s2ram), but they are _not_ related to the
freezing of kernel threads.  Some of them are related to the other issue that
you have risen, which is that the same callbacks should not be used for the
suspend and hibernation, and which I think is absolutely valid.  The remaining
ones are related to the fact that graphic card vendors don't care for us at
all.

> Ie we do have history of _not_ freezing things.  The freezing came later, 
> and came with the subsystem that had more problems..

It doesn't have that many problems as you are trying to suggest.  At present,
the only problems with it happen if someone tries to "improve" it in the way
I did with the workqueues.

Anyway, the freezing of tasks, including kernel threads, is one of the few
things on which Pavel, Nigel and me completely agree that they should be done,
so perhaps you could accept that?

Greetings,
Rafael

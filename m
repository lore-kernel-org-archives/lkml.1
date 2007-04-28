Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbXD1XAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbXD1XAg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbXD1XAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:00:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35165 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbXD1W7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:59:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Back to the future.
Date: Sun, 29 Apr 2007 01:03:37 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704281950.30405.rjw@sisk.pl> <alpine.LFD.0.98.0704281421140.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704281421140.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704290103.38409.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 23:25, Linus Torvalds wrote:
> 
> On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> > > 
> > > The freezer has *caused* those deadlocks (eg by stopping threads that were 
> > > needed for the suspend writeouts to succeed!), not solved them.
> > 
> > I can't remember anything like this, but I believe you have a specific test
> > case in mind.
> 
> Ehh.. Why do you thik we _have_ that PF_NOFREEZE thing in the first place?

Well, I don't know why exactly it had been originally introduced.  Currently,
it is used by the threads that should be running after the snapshot is done
(they are not only I/O threads).

> Rafael, you really don't know what you're talking about, do you?

I think I know.

> Just _look_ at them. It's the IO threads etc that shouldn't be frozen, 
> exactly *because* they do IO. You claim that kernel threads shouldn't do 
> IO, but that's the point: if you cannot do IO when snapshotting to disk,  
> here's a damn big clue for you: how do you think that snapshot is going to 
> get written?

OK, more precisely: fs-related threads should not try to process their queues,
etc., after the snapshot is done, because that may cause some fs data to be
written at that time and then the fs in question may be corrupted after the
restore.  Not all of the I/O in general, fs data.

Still, that alone probably is not a good enough reason for freezing all kernel
threads.

> I *guarantee* you that we've had a lot more problems with threads that 
> should *not* have been frozen than with those hypothetical threads that 
> you think should have been frozen.

Well, I'm not sure whether or not that still would have been the case if we had
stopped to freeze kernel threads for the hibernation/suspend.  I just see
potential problems that I've mentioned in the previous message and I don't see
any evidence that they cannot occur.

Greetings,
Rafael

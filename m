Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbXD0XRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbXD0XRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757888AbXD0XRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:17:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59119 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757883AbXD0XRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:17:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Lang <david.lang@digitalinsight.com>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 01:21:07 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280041.17617.rjw@sisk.pl> <Pine.LNX.4.63.0704271521230.10565@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0704271521230.10565@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280121.08553.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 00:26, David Lang wrote:
> On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> 
> >>> We're freezing many of them just fine. ;-)
> >>
> >> And can you name a _single_ advantage of doing so?
> >
> > Yes.  We have a lot less interdependencies to worry about during the whole
> > operation.
> >
> >> It so happens, that most people wouldn't notice or care that kmirrord got
> >> frozen (kernel thread picked at random - it might be one of the threads
> >> that has gotten special-cased to not do that), but I have yet to hear a
> >> single coherent explanation for why it's actually a good idea in the first
> >> place.
> >
> > Well, I don't know if that's a 'coherent' explanation from your point of view
> > (probably not), but I'll try nevertheless:
> > 1) if the kernel threads are frozen, we know that they don't hold any locks
> > that could interfere with the freezing of device drivers,
> 
> does teh process of freezing really wait until all locks have been released?

Yes, it does.

> > 2) if they are frozen, we know, for example, that they won't call user mode
> > helpers or do similar things,
> 
> this won't matter unless the user mode helpers are going to do I/O or other 
> permanent changes

Please note that even accessing a file may be a permanent change.

> > 3) if they are frozen, we know that they won't submit I/O to disks and
> > potentially damage filesystems (suspend2 has much more problems with that
> > than swsusp, but still.  And yes, there have been bug reports related to it,
> > so it's not just my fantasy).
> 
> if you have the filesystems checkpointed then I/O after the freeze won't matter 
> as you just revert to the checkpoint (and since this is going to be thrown away 
> it can stay in ram)

In that case, I would agree.  Currently, however, we're not even close to this
point.

The checkpointing of filesystems would be a very welcome feature, but there's
no anyone working on it right now, AFAICT.

> if we are willing to make a break with the past to implement the new snapshot 
> capability, we should be able to use the LVM snapshot code to handle the 
> filesystem

Yes, we can do that, in principle, and screw all of the current users in the
process.  And finally we'd end up with something similar to what is done now,
IMHO.

And no, the things are not just totally broken, as it may follow from these
discussions.  The problem is that the people who are discussing them so
viciously have never tried to write anything like the hibernation code.

This is as though as I were discussing the design of the CPU schedulers,
although I only know how they work on a general level.

Actually, the really problematic thing with the hibernation _right_ _now_ is
what Linus is so concerned about (and rightfully so) - that we use the
same device drivers' callbacks for the hibernation and suspend (aka s2ram).
The other things work quite well and are really robust.

Greetings,
Rafael

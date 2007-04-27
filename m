Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXD0Xl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXD0Xl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbXD0Xl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:41:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59230 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909AbXD0Xl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:41:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 01:45:25 +0200
User-Agent: KMail/1.9.5
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280041.17617.rjw@sisk.pl> <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280145.26253.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 01:17, Linus Torvalds wrote:
> 
> On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> >
> > > And can you name a _single_ advantage of doing so?
> > 
> > Yes.  We have a lot less interdependencies to worry about during the whole
> > operation.
> 
> That's not an advantage. That's why it has *sucked*.

Actually, the less things happen while we're creating and saving the image,
the less sources of potential problems there are and by freezing the kernel
threads (not all of them), we cause less things to happen at that time.

To make you happy, we could stop doing that, but what actual _advantage_
that would bring?

> Trying to freeze kernel threads has _caused_ problems. It has _added_ 
> these interdependencies. It hasn't removed a single dependency at any 
> time, it has just added new problems!

What problems are you talking about?

> > 1) if the kernel threads are frozen, we know that they don't hold any locks
> > that could interfere with the freezing of device drivers,
> > 2) if they are frozen, we know, for example, that they won't call user mode
> > helpers or do similar things,
> > 3) if they are frozen, we know that they won't submit I/O to disks and
> > potentially damage filesystems (suspend2 has much more problems with that
> > than swsusp, but still.  And yes, there have been bug reports related to it,
> > so it's not just my fantasy).
> 
> NONE of these are valid explanations at all. You're listing totally 
> theoretical problems, and ignoring all the _real_ problems that trying to 
> freeze kernel threads has _caused_.

Example, please?

> If you want to control user-mode helpers, you do that - you do not freeze 
> kernel threads!
> 
> And no, kernel threads do not submit IO to disks on their own. You just 
> made that up.

No, I didn't.  Nigel can confirm, I think.

> Yes, they can be involved in that whole disk submission thing, but in a good
> way - they can be required in order to make disk writing work!

Some of them can be, some other's need not be.  We don't need any fs-related
kernel threads for saving the image, for example.

> The problem that suspend has had is that it's done everything totally the 
> wrong way around. Do kernel threads do disk IO? Sure, if asked to do so. 

They can be asked before we do the snapshot and complete the operation
afterwards, no?

> For example, kernel threads can be involved in md etc, but that's a *good* 
> thing.

We don't freeze these threads.

> The way to shut them up is not to freeze the threads, but to freeze the *disk*.

In principle, you're right.  In practice, go and try it.

Anyway, why is it so important that _all_ of the kernel threads be running
while the snapshot is created and saved?

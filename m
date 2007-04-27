Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbXD0WhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbXD0WhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbXD0WhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:37:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58992 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507AbXD0WhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:37:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 00:41:17 +0200
User-Agent: KMail/1.9.5
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280004.47683.rjw@sisk.pl> <alpine.LFD.0.98.0704271506080.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704271506080.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280041.17617.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 00:08, Linus Torvalds wrote:
> 
> On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> > 
> > We're freezing many of them just fine. ;-)
> 
> And can you name a _single_ advantage of doing so?

Yes.  We have a lot less interdependencies to worry about during the whole
operation.

> It so happens, that most people wouldn't notice or care that kmirrord got 
> frozen (kernel thread picked at random - it might be one of the threads 
> that has gotten special-cased to not do that), but I have yet to hear a 
> single coherent explanation for why it's actually a good idea in the first 
> place.

Well, I don't know if that's a 'coherent' explanation from your point of view
(probably not), but I'll try nevertheless:
1) if the kernel threads are frozen, we know that they don't hold any locks
that could interfere with the freezing of device drivers,
2) if they are frozen, we know, for example, that they won't call user mode
helpers or do similar things,
3) if they are frozen, we know that they won't submit I/O to disks and
potentially damage filesystems (suspend2 has much more problems with that
than swsusp, but still.  And yes, there have been bug reports related to it,
so it's not just my fantasy).

Probably some other people can say more about it.

> And it has added totally idiotic code to every single kernel thread main 
> loop. For _no_ reason, except that the concept was broken, and needed more 
> breakage to just make it work.

It is actually useful for some things other than the hibernation/suspend, the
code is not idiotic (it's one line of code in the majority of cases) and you
should take that "I hate everything even remotely related to hibernation" hat
off, really.

Greetings,
Rafael

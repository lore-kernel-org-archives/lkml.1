Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbXD0XSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbXD0XSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbXD0XSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:18:11 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757880AbXD0XSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:18:09 -0400
Date: Fri, 27 Apr 2007 16:17:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704280041.17617.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280004.47683.rjw@sisk.pl>
 <alpine.LFD.0.98.0704271506080.9964@woody.linux-foundation.org>
 <200704280041.17617.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
>
> > And can you name a _single_ advantage of doing so?
> 
> Yes.  We have a lot less interdependencies to worry about during the whole
> operation.

That's not an advantage. That's why it has *sucked*.

Trying to freeze kernel threads has _caused_ problems. It has _added_ 
these interdependencies. It hasn't removed a single dependency at any 
time, it has just added new problems!

> 1) if the kernel threads are frozen, we know that they don't hold any locks
> that could interfere with the freezing of device drivers,
> 2) if they are frozen, we know, for example, that they won't call user mode
> helpers or do similar things,
> 3) if they are frozen, we know that they won't submit I/O to disks and
> potentially damage filesystems (suspend2 has much more problems with that
> than swsusp, but still.  And yes, there have been bug reports related to it,
> so it's not just my fantasy).

NONE of these are valid explanations at all. You're listing totally 
theoretical problems, and ignoring all the _real_ problems that trying to 
freeze kernel threads has _caused_.

If you want to control user-mode helpers, you do that - you do not freeze 
kernel threads!

And no, kernel threads do not submit IO to disks on their own. You just 
made that up. Yes, they can be involved in that whole disk submission 
thing, but in a good way - they can be required in order to make disk 
writing work!

The problem that suspend has had is that it's done everything totally the 
wrong way around. Do kernel threads do disk IO? Sure, if asked to do so. 
For example, kernel threads can be involved in md etc, but that's a *good* 
thing. The way to shut them up is not to freeze the threads, but to freeze 
the *disk*.

		Linus

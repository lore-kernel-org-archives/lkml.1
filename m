Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbZLMBP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbZLMBP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932261AbZLMBPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:15:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40331 "HELO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932256AbZLMBPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:15:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sat, 12 Dec 2009 18:35:40 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912111938310.32493-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912111938310.32493-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912121835.40663.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 December 2009, Alan Stern wrote:
> On Sat, 12 Dec 2009, Rafael J. Wysocki wrote:
> 
> > Below is a patch I've just tested, but there's a lockdep problem in it I don't
> > know how to solve.  Namely, lockdep is apparently unhappy with us not releasing
> > the lock taken in device_suspend() and it complains we take it twice in a row
> > (which we do, but for another device).  I need to use down_read_non_owner()
> > to make it shut up and then I also need to use up_read_non_owner() in
> > __device_suspend(), although there's the comment in include/linux/rwsem.h
> > saying exatly this about that:
> > 
> > /*
> >  * Take/release a lock when not the owner will release it.
> >  *
> >  * [ This API should be avoided as much as possible - the
> >  *   proper abstraction for this case is completions. ]
> >  */
> > 
> > (I'd like to know your opinion about that).  Yet, that's not all, because next
> > it complains during resume that __device_resume() releases a lock it didn't
> > acquire, which it clearly does, but that is intentional.  Unfortunately,
> > there's no up_write_non_owner() ...
> 
> Hah!  I knew it!
> 
> How come lockdep didn't complain earlier?  What's different about this 
> patch?  Only the nesting annotations?  Why should adding annotations 
> make lockdep less happy?

I'm not sure.  Perhaps I made a mistake during the previous tests.

Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbZBQXWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbZBQXWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZBQXWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:22:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35970 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbZBQXWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:22:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFD] Automatic suspend
Date: Wed, 18 Feb 2009 00:21:58 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902162156380.24097-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902162156380.24097-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200902180022.00239.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 February 2009, Alan Stern wrote:
> On Tue, 17 Feb 2009, Rafael J. Wysocki wrote:
> 
> > Phase 1: I agree that system-auto-suspend-on, system-auto-suspend-off would be
> > useful, but I don't like the wakelocks interface.  Do you think there is an
> > alternative way/mechanism of doing this?
> 
> I rather like the suggestions Matthew Garrett has been making.  They 
> show how to improve the wakelock interface without losing any function.
> 
> Really, the idea behind wakelocks comes down to the question of how to
> determine when the system is sufficiently idle to go into auto-suspend.  
> There may be occasions when no task is runnable but userspace knows
> that the system should not go to sleep because some work will be done
> in the near future.  (Arve's example of a non-empty input buffer is
> such a case.)  How should userspace let the kernel know whether it's
> okay to suspend at these times?  That is the problem userspace
> wakelocks are meant to solve.

Still, do we really need multiple user space wakelocks (I'd prefer to call them
sleeplocks)?  It seems that one such lock and a user space manager controlling
it should be sufficient.

> Kernel wakelocks are a separate matter.  They are more like a form of 
> optimization, preventing the kernel from starting an auto-suspend when 
> some driver knows beforehand that it will return -EBUSY.

I think kernel-side autosuspend (or rather autosleep) should only happen
after certain subset of devices have been suspended using a per-device
run-time autosuspend mechanism.

> > Phase 3: Probably explicit control left to open/close.
> 
> While that's generally a good idea, it's important to recognize that 
> some devices should be runtime-suspended even while they are open.

>From the kernel side, yes (and that should be transparent to the user space
having them open).  By the user space, no.
 
> Basically, any device that is "always open" falls in this category.  
> Some examples are the screen, the keyboard, the mouse, and disk drives.  
> And of course, some of these things already have runtime power 
> management.

Thanks,
Rafael

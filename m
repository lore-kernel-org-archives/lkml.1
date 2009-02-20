Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZBTU4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZBTU4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 15:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZBTU4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 15:56:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57335 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbZBTU4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 15:56:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [RFD] Automatic suspend
Date: Fri, 20 Feb 2009 21:56:11 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902192215.18365.rjw@sisk.pl> <200902201657.01145.rjw@sisk.pl> <f73f7ab80902200807j743a37d7hc42283bc7b9dbe6f@mail.gmail.com>
In-Reply-To: <f73f7ab80902200807j743a37d7hc42283bc7b9dbe6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902202156.13480.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009, Kyle Moffett wrote:
> On Fri, Feb 20, 2009 at 10:56 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > * Introduce /sys/power/sleep that will work like /sys/power/state, but:
> >  - First, it will call ->acknowledge() for each driver (via bus types) to
> >    check if any of them wants to postpone the suspend (this will prevent tasks
> >    from being frozen unnecessarily if it is known in advance that the suspend
> >    should not happen at the moment).
> >  - Next, it will check the "I_do_not_want_automatic_suspend_to_occur" flag
> >    of each process and the suspend will be aborted if it is true for any of
> >    them (quite frankly, I think that should be integrated with the freezer,
> >    in particular the tasks that have TIF_FREEZE set shouldn't be able to set
> >    this flag and it should be checked in the freezer loop for every task with
> >    TIF_FREEZE unset).
> >  - Next, it will proceed with suspending just like /sys/power/state does (the
> >    drivers that missed the opportunity to abort the suspend by returning
> >    'false' from ->acknowledge() can still abort the suspend by failing their
> >    ->suspend() routines).
> >
> > Then, the decision making logic will be able to use /sys/power/sleep whenever
> > it wishes to and the kernel will be able to refuse to suspend if it's not
> > desirable at the moment.
> 
> Then, for a userspace process handling input events:
> 
> 1)  Unset "no-suspend flag"
> 2)  Poll event device
> 3)  When the poll returns true, set the "no-suspend flag"
> 4)  Read the event device and process the event(s)
> 5)  Go back to step 1
> 
> The event driver would responsible for atomically preventing suspend
> from the moment a button is pressed until it is actually delivered to
> a userspace process.  Since at that time the userspace process will be
> preventing suspend, there will be no window in which we could go to
> sleep with pending events.

That's correct.

How would you like to prevent it from happening?

Rafael

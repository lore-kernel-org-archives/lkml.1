Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZH3NJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZH3NJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZH3NJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:09:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48742 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbZH3NJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:09:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2/6] PM: Asynchronous resume of devices
Date: Sun, 30 Aug 2009 15:09:50 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908282146550.9540-100000@netrider.rowland.org> <200908291449.57667.rjw@sisk.pl> <20090830064533.GA1417@ucw.cz>
In-Reply-To: <20090830064533.GA1417@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908301509.50855.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 August 2009, Pavel Machek wrote:
> Hi!
> 
> > > > > > > The same goes for the noirq versions.
> > > > > > 
> > > > > > I thought about that, but there are a few things to figure out:
> > > > > > - how many threads to start
> > > > > 
> > > > > That's a tough question.  Right now you start roughly as many threads
> > > > > as there are async devices.  That seems like overkill.
> > > > 
> > > > In fact they are substantially fewer than that, for the following reasons.
> > > > 
> > > > First, the async framework will not start more than MAX_THREADS threads,
> > > > which is 256 at the moment.  This number is less than the number of async
> > > > devices to handle on an average system.
> > > 
> > > Okay, but MAX_THREADS isn't under your control.  Remember also that 
> > > each thread takes up some memory, and during hibernation we are in a 
> > > memory-constrained situation.
> > 
> > We keep some extra free memory for things like this.  It's not likely to be
> > exhausted by the async threads alone.
> 
> What extra memory? You are creating quite a lot of threads. For 256 of
> them, it would take cca 2MB...

We never start that many threads and even if there's not enough memory to
start a new thread, the async framework will handle that for us.

> You recently removed code from s2disk that freed 4MB of extra memory,

That was removed from s2ram.  For STD we still have PAGES_FOR_IO and
SPARE_PAGES, nothing's changed there.

Thanks,
Rafael

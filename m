Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZH3Gpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZH3Gpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 02:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZH3Gpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 02:45:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43177 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbZH3Gpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 02:45:39 -0400
Date: Sun, 30 Aug 2009 08:45:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/6] PM: Asynchronous resume of devices
Message-ID: <20090830064533.GA1417@ucw.cz>
References: <Pine.LNX.4.44L0.0908282146550.9540-100000@netrider.rowland.org> <200908291449.57667.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908291449.57667.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > > The same goes for the noirq versions.
> > > > > 
> > > > > I thought about that, but there are a few things to figure out:
> > > > > - how many threads to start
> > > > 
> > > > That's a tough question.  Right now you start roughly as many threads
> > > > as there are async devices.  That seems like overkill.
> > > 
> > > In fact they are substantially fewer than that, for the following reasons.
> > > 
> > > First, the async framework will not start more than MAX_THREADS threads,
> > > which is 256 at the moment.  This number is less than the number of async
> > > devices to handle on an average system.
> > 
> > Okay, but MAX_THREADS isn't under your control.  Remember also that 
> > each thread takes up some memory, and during hibernation we are in a 
> > memory-constrained situation.
> 
> We keep some extra free memory for things like this.  It's not likely to be
> exhausted by the async threads alone.

What extra memory? You are creating quite a lot of threads. For 256 of
them, it would take cca 2MB... You recently removed code from s2disk
that freed 4MB of extra memory, so you are now essentially relying on
min_free_kbytes -- and even then is not reliable, user might s2disk
under memory pressure. min_free_kbytes is 1MB on my system.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

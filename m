Return-Path: <linux-kernel-owner+w=401wt.eu-S935001AbYCSUsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935001AbYCSUsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbYCSTpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:45:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57296 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758529AbYCSTpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:45:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks
Date: Wed, 19 Mar 2008 02:04:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20080318100106.GA10830@elf.ucw.cz> <Pine.LNX.4.44L0.0803181103410.1476-100000@netrider.rowland.org> <20080318235457.GA1936@elf.ucw.cz>
In-Reply-To: <20080318235457.GA1936@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803190204.07592.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Pavel Machek wrote:
> Hi!

Hi,

> > > So... we do prepare() but it detects new child, so it returns -EAGAIN.
> > >   so we call complete() based on description above
> > > ...and then we call prepare() to suspend again?
> > 
> > You misunderstood (maybe the comment needs to be clarified as above).  
> 
> Yes, please :-).
> 
> > If prepare() returns any error (including -EAGAIN) then complete() does
> > not get called.  If prepare() returns successfully but the PM core
> > detects that a new child was added while prepare() was running, then we
> > call complete(), suspend the child, and call prepare() again.
> 
> Ok.
> 
> > > > + * @suspend: Executed before putting the system into a sleep state in which the
> > > > + *	contents of main memory are preserved.  Quiesce the device, put it into
> > > 
> > > content....is?
> > 
> > It's okay to use "contents" -- analogous to the table of contents in a
> > book.  It's one of those weird corner cases where either alternative is
> > acceptable.
> 
> Ok -- I guess I should get that english course ;-).

Thanks for the comments.

In the meantime I had an IRC chat with Ben, who wanted a couple of quite
substantial changes to be made to this patch.

First, Ben thinks that ->prepare() should be called in a separate loop for
all devices, before any of them is suspended, so that drivers can assume the
availability of the other devices during ->prepare() (for example, so that they
can use GFP_KERNEL memory allocations).  Accordingly, ->complete() would
be called in a separate loop after calling ->resume() for all devices.

Next, he wants the number of noirq callbacks to be reduced.

Both of the above things make sense, so I'll rework the patch (or maybe even
all three patches) to implement them and we'll see how they will look like.

Thanks,
Rafael

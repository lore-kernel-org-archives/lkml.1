Return-Path: <linux-kernel-owner+w=401wt.eu-S1161041AbYCSXkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161041AbYCSXkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939759AbYCSWJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:09:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2339 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S939754AbYCSWJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:09:23 -0400
Date: Tue, 18 Mar 2008 11:10:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
 hibernation callbacks
In-Reply-To: <20080318100106.GA10830@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0803181103410.1476-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008, Pavel Machek wrote:

> > + * @complete: Undo the changes made by @prepare().  This method is executed for
> > + *	all kinds of resume transitions, immediately following one of the resume
> > + *	callbacks: @resume(), @thaw(), @restore(), or @recover().  Also executed
> > + *	if a suspend callback (@suspend(), @freeze(), @poweroff(), @quiesce())
> > + *	immediately following a successful @prepare() fails OR if a new child
> > + *	of the device has been registered during @prepare().

"during a successful call to @prepare()"?

> So... we do prepare() but it detects new child, so it returns -EAGAIN.
>   so we call complete() based on description above
> ...and then we call prepare() to suspend again?

You misunderstood (maybe the comment needs to be clarified as above).  

If prepare() returns any error (including -EAGAIN) then complete() does
not get called.  If prepare() returns successfully but the PM core
detects that a new child was added while prepare() was running, then we
call complete(), suspend the child, and call prepare() again.

> > + * @suspend: Executed before putting the system into a sleep state in which the
> > + *	contents of main memory are preserved.  Quiesce the device, put it into
> 
> content....is?

It's okay to use "contents" -- analogous to the table of contents in a
book.  It's one of those weird corner cases where either alternative is
acceptable.

Alan Stern


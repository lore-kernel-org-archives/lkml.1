Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbXGDKNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbXGDKNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbXGDKNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:13:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48412 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757669AbXGDKNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:13:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 12:21:04 +0200
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <fa.ftLWBLCc+XqdYjiuxoPg+qyuUOE@ifi.uio.no> <468AE700.7080102@shaw.ca> <20070704003424.GA30958@srcf.ucam.org>
In-Reply-To: <20070704003424.GA30958@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041221.04708.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 4 July 2007 02:34, Matthew Garrett wrote:
> On Tue, Jul 03, 2007 at 06:17:04PM -0600, Robert Hancock wrote:
> > Matthew Garrett wrote:
> > >Leave the process blocked and defer any i/o until after resume. Why does 
> > >it need to be any more complicated than that?
> > 
> > It gets complicated when this has to be added and TESTED in EVERY 
> > driver. The implied contract for drivers previously was that their 
> > device would not get accessed after it was suspended until it had been 
> > resumed first. This proposed change violates that.
> 
> No, that's only ever been true for ACPI systems.

Sorry, but you're mistaken.

Some ARM platforms also use the suspend code in kernel/power and the 52xx
powerpc too (BTW, I don't know of any ARM platforms that support suspend and
don't use it).

> It's never been true elsewhere, and it won't be true for anything
> implementing any sort of runtime power management.

There are not many drivers in the tree supporting that right now.

> > I don't think this sort of handling is something that individual drivers 
> > should have to deal with (at least not ones that are part of a framework 
> > like USB, libata, etc.)
> 
> I'd agree there. Driver midlayers (where they exist) are the appropriate 
> place to handle this.

So perhaps we should modify them first and we can drop the freezer?

Perhaps we can schedule the freezer removal (from the suspend code path), so
that people have the time to rework the driver midlayers to take that into
account?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0BHGzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 01:55:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39931 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab0BHGzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 01:55:45 -0500
Date: Mon, 8 Feb 2010 07:55:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100208065537.GF1290@ucw.cz>
References: <201002021408.51851.oliver@neukum.org> <Pine.LNX.4.44L0.1002021208100.1805-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002021208100.1805-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-02-02 12:11:25, Alan Stern wrote:
> On Tue, 2 Feb 2010, Oliver Neukum wrote:
> 
> > Am Dienstag, 2. Februar 2010 13:39:35 schrieb Catalin Marinas:
> > > > For storage that is correct. But what about other sources of pages,
> > > > for example iSCSI?
> > > 
> > > In the iSCSI case, does the HCD driver write directly to a page cache
> > > page? Or it just fills in network packets that are copied to page cache
> > > pages by the iSCSI code (sorry, I'm not familiar with this part of the
> > > kernel). If the latter, the cache flushing in the HCD driver would not
> > > help and it needs to be done in the iSCSI code.
> > 
> > As far as I can tell iSCSI does a private copy. But I don't know how
> > many methods to transfer code pages over USB exist. I'd say the
> > conservative solution is to flush for everything but control transfers.
> 
> This doesn't make any sense.  Nobody would ever use isochronous 
> transfers to store data into a code page because isochronous is 
> unreliable.  (Audio isn't a counterexample -- audio data may be

Why not?

Use isochronous transfer to load data, verify it is okay, exec it.

Or maybe someone is doing crashme testing with usb audio as random
generator :-).

Sure, unlikely, but...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

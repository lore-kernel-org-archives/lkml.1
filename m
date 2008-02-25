Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYBYLnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYBYLnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYBYLnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:43:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57968 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbYBYLnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:43:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Mon, 25 Feb 2008 12:41:25 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0802242119500.31164-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802242119500.31164-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251241.26216.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of February 2008, Alan Stern wrote:
> On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:
> 
> > > Very subtly wrong ;-).
> > > 
> > > imagine suspending_task == 0xabcdef01. Now task "R" with current ==
> > > 0xabcd0000 reads suspending_task while the other cpu is writing to it,
> > > and sees 0xabcd0000 (0xef01 was not yet written) -- and mistakenly
> > > believes that  "R" == suspending_task.
> > > 
> > > I agree it is very unlikely, and it will not happen on i386. But what
> > > about just using atomic_t suspending_task, and store current->pid into
> > > it?
> > 
> > I'd rather use a lock, frankly.  For example, we can require the readers to
> > take pm_sleep_rwsem for reading in order to access that.
> 
> That certainly won't work.  Imagine what would happen when the reader 
> _was_ the suspending task.

Yeah, I've already realized it was a stupid idea. :-)

> But if you really twist my arm, I'll go along with Pavel's suggestion.

So can you do that, pretty please?

Thanks,
Rafael

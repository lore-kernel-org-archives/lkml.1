Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYBYCV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYBYCV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 21:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYBYCVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 21:21:51 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3369 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751651AbYBYCVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 21:21:50 -0500
Date: Sun, 24 Feb 2008 21:21:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <200802242321.22665.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802242119500.31164-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:

> > Very subtly wrong ;-).
> > 
> > imagine suspending_task == 0xabcdef01. Now task "R" with current ==
> > 0xabcd0000 reads suspending_task while the other cpu is writing to it,
> > and sees 0xabcd0000 (0xef01 was not yet written) -- and mistakenly
> > believes that  "R" == suspending_task.
> > 
> > I agree it is very unlikely, and it will not happen on i386. But what
> > about just using atomic_t suspending_task, and store current->pid into
> > it?
> 
> I'd rather use a lock, frankly.  For example, we can require the readers to
> take pm_sleep_rwsem for reading in order to access that.

That certainly won't work.  Imagine what would happen when the reader 
_was_ the suspending task.

But if you really twist my arm, I'll go along with Pavel's suggestion.

Alan Stern


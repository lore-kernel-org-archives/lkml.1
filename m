Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYBXUdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYBXUdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 15:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYBXUdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 15:33:05 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2775 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752594AbYBXUdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 15:33:04 -0500
Date: Sun, 24 Feb 2008 15:33:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <20080224201105.GC18908@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0802241527420.11316-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Pavel Machek wrote:

> > > What locking protects this variable? What happens when suspending_task
> > > exits? (Hmm, that would probably be bug, anyway?)
> > 
> > It's protected by whatever existing locking scheme allows only one
> > task to start a system sleep at a time.  For example, the suspending 
> > task has to get a write lock on pm_sleep_rwsem.
> 
> And readers of suspending_task are protected by?

I added a comment about that too.

> At the very least, you'd need rmb() before reading it and wmb() after
> writing to it, but I'm not sure if that's enough on every obscure
> architecture out there.

No, neither one is needed because of the way suspending_task is used.  

It's not necessary for a reader R to see the variable's actual value;  
all R needs to know is whether or not suspending_task is equal to R.  
Since the only process which can set suspending_task to R is R itself,
and since R will set suspending_task back to NULL before releasing the
write lock on pm_sleep_rwsem, there's never any ambiguity.

Alan Stern


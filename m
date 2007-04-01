Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbXDASet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbXDASet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933832AbXDASet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:34:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41087 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933827AbXDASes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:34:48 -0400
Date: Sun, 1 Apr 2007 20:34:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Zeuthen <davidz@redhat.com>, Maxim <maximlevitsky@gmail.com>,
       Pete Zaitcev <zaitcev@redhat.com>, gregkh@suse.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
Message-ID: <20070401183437.GH11146@elf.ucw.cz>
References: <20070401175020.GE11146@elf.ucw.cz> <Pine.LNX.4.44L0.0704011422460.1054-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0704011422460.1054-100000@netrider.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Problem is that suspending _with_ removable mass storage devices
> > attached just will not work. User will unplug them, then complain
> > about corruption. Advanced user will unplug them, work with them
> > somewhere else, replug them, then loose filesystem.
> > 
> > Feel free to send patch to teach filesystems to handle this.
> 
> Actually what's needed is a Persistent Logical Volume Manager.  With it,
> you could even mount a filesystem on a USB device, unplug the device, plug
> it back into a different port, and still be able to use the filesystem.
> 
> But you're still likely to run into trouble if you unplug a storage
> device, move it to another system and write on it, then plug it back into
> the original system.  The PLVM would somehow have to recognize that the
> data had been changed.  I don't know a foolproof way of doing that.

Such detection should be possible when done at filesystem level.

I.e. ext3 would notice that someone replayed the journal.

Or we could create ext5 where each r/w mount would update mount
time... actually we probably already have last mount time in ext3,
so...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbYFIMCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbYFIMCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYFIMB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:01:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52573 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbYFIMB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:01:57 -0400
Date: Mon, 9 Jun 2008 10:00:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linuxfoundation.org>, gregkh@suse.de,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
Message-ID: <20080609080052.GA27899@elf.ucw.cz>
References: <20080606092546.GA2596@elf.ucw.cz> <Pine.LNX.4.44L0.0806061030210.2354-100000@iolanthe.rowland.org> <20080607195221.GB11109@ucw.cz> <alpine.LFD.1.10.0806071525030.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806071525030.3473@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sat 2008-06-07 15:26:12, Linus Torvalds wrote:
> On Sat, 7 Jun 2008, Pavel Machek wrote:
> > Well, not-usb-persists means we force-unplug disks during suspend,
> > after syncing them. Not _too_ bad.
> > 
> > If you unplug disk while hibernated, modify it, and plug it back,
> > youget _silent_ filesystem corruption. I call that bad.
> 
> .. and if the USB layer unplugs them unconditionally while the filesystem 
> is mounted, you _unconditionally_ get a system that doesn't work.

If your device did not loose power during s2ram, it should just work.

There's a tweak you can set in /sys you can set if your device is not
removable, you can set it for non-removable devices that _do_ loose
power.

Besides, it seems to break suspend/resume of printers, and probably
all the drivers that do not have reset_resume() method. That's
actually a regression.

https://bugzilla.novell.com/show_bug.cgi?id=394820

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

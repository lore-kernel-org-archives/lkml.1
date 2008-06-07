Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbYFGT6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbYFGT6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYFGT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:57:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1576 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753177AbYFGT55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:57:57 -0400
Date: Sat, 7 Jun 2008 21:52:22 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>, Linus Torvalds <torvalds@osdl.org>
Cc: gregkh@suse.de, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
Message-ID: <20080607195221.GB11109@ucw.cz>
References: <20080606092546.GA2596@elf.ucw.cz> <Pine.LNX.4.44L0.0806061030210.2354-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0806061030210.2354-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-06-06 10:39:19, Alan Stern wrote:
> On Fri, 6 Jun 2008, Pavel Machek wrote:
> 
> > Hi!
> > 
> > In 2.6.26-rc5, 
> > 
> > -config USB_PERSIST
> > -       bool "USB device persistence during system suspend (DANGEROUS)"
> > 
> > is now on. Given that it was previously marked "DANGEROUS", that seems
> > quite a change to me.
> 
> It is.  Basically I did it because Linus asked for it -- or at least,
> for something like it.  He felt that the danger of not having
> USB_PERSIST when you need it is worse than the danger of having it when
> you don't want it.

Well, not-usb-persists means we force-unplug disks during suspend,
after syncing them. Not _too_ bad.

If you unplug disk while hibernated, modify it, and plug it back,
youget _silent_ filesystem corruption. I call that bad.

> > Besides, it seems to have broken usblp hibernation support, and maybe
> > other devices that does not have reset_resume() present. (Big thanks
> > for Oliver for doing investigation).
> 
> URL?  It's hard to see how lack of reset-resume support would mess 
> anything up worse than it would be without USB_PERSIST.

usblp driver sets 'suspended' flag in .suspend(), and resets it in
.resume() -- except that with USB_PERSIST .resume() is not called :-(.

I have novell bugzilla bug number somewhere...

> > [Or is it that now USB_PERSIST is conditional on /sys fs setting, so
> > while setting it on individual device is dangerous, it is still N by
> > default? Changelog does not tell me...?]
> 
> USB_PERSIST is (and has always been) conditional on the power/persist
> sysfs attribute setting.  The difference is that now the setting starts
> out as On whereas before it started out as Off, and there no longer is
> a Kconfig option to remove USB_PERSIST entirely.

I consider the default to be dangerous here.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

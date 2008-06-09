Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYFIV4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYFIV4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYFIVz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:55:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43457 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYFIVz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:55:59 -0400
Date: Mon, 9 Jun 2008 23:56:51 +0200
From: Pavel Machek <pavel@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Linus Torvalds <torvalds@linuxfoundation.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
Message-ID: <20080609215651.GF21429@elf.ucw.cz>
References: <200806091712.46869.oliver@neukum.org> <Pine.LNX.4.44L0.0806091142390.2943-100000@iolanthe.rowland.org> <20080609195015.GA6601@suse.de> <20080609205916.GC21429@elf.ucw.cz> <alpine.LFD.1.10.0806091435120.3218@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806091435120.3218@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-06-09 14:39:10, Linus Torvalds wrote:
> 
> 
> On Mon, 9 Jun 2008, Pavel Machek wrote:
> > 
> > I believe we should just revert the "CONFIG_USB_PERSIST force on"
> > patch, and solve this properly in 2.6.27.
> 
> Why?
> 
> The code would _still_ be buggy with that revert in place. You have to 
> enable CONFIG_USB_PERSIST just to get even the _possibility_ of the sane 
> behavior. 
> 
> If there is a problem with usblp, it just needs to be fixed. 

With USB_PERSIST on, you have problem on all drivers but usb-storage,
AFAICT... because usb-storage seems to be the only driver implementing
reset_resume.

I guess it is possible to do something like "if reset_resume() is
unavailable, try plain resume()" in usb/driver.c, but I'd really
changes to the suspend/resume callback to go in -rc1 so that they are
tested properly, and not hot-patch it now.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

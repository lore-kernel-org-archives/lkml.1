Return-Path: <linux-kernel-owner+w=401wt.eu-S1030865AbXDMWlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030865AbXDMWlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030477AbXDMWlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:41:03 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37008 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030869AbXDMWlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:41:01 -0400
Date: Sat, 14 Apr 2007 00:40:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: nigel@nigel.suspend2.net, Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org
Subject: Re: [RFD] swsusp problem: Drivers allocate much memory during suspend (was: Re: 2.6.21-rc5: swsusp: Not enough free memory)
Message-ID: <20070413224053.GT28264@elf.ucw.cz>
References: <460B6E4B.3060004@gmail.com> <200704132241.52725.rjw@sisk.pl> <20070413221016.GQ28264@elf.ucw.cz> <200704140035.36355.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704140035.36355.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > Well, it looks like someone allocated about 6000 pages after we had freed
> > > > > enough memory for suspending.
> > > > 
> > > > We have a tunable allowance in Suspend2 for this, because fglrx
> > > > allocates a lot of pages in its suspend routine if DRI is enabled. I
> > > > think some other drivers do too, but fglrx is the main one I know.
> > > 
> > > I wasn't aware of that, thanks for the information.
> > > 
> > > I think this means we'll probably need to add a tunable, similar to image_size,
> > > that will allow the users to specify how much spare memory they want to reserve
> > > for suspending (instead of the constant PAGES_FOR_IO).  IMO we can call it
> > > 'spare_memory'.
> > 
> > Just increase PAGES_FOR_IO. This should not be tunable.
> 
> Well, I'm not sure.  First, we don't really know what the value of it should be
> and this alone is a good enough reason for making it tunable, IMHO.  Second, I
> think different systems may need different PAGES_FOR_IO and taking just the
> maximum (even if we learn how much that actually is) seems to be wasteful in

Well,  it is wasteful as in "we save slightly smaller image than we
could". That's okay with me.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

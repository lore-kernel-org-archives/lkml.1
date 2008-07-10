Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbYGJSLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbYGJSLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758952AbYGJSKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:10:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4527 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757190AbYGJSKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:10:52 -0400
Date: Thu, 10 Jul 2008 20:10:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: Giacomo Mulas <gmulas@ca.astro.it>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       debian-kernel@lists.debian.org,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: b43 locks the machine when resuming after suspend to disk
Message-ID: <20080710181038.GA13483@ucw.cz>
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it> <200807022340.31894.rjw@sisk.pl> <1215039419.13270.18.camel@johannes.berg> <200807030108.37614.rjw@sisk.pl> <1215040064.13270.20.camel@johannes.berg> <alpine.DEB.1.10.0807031118590.2010@capitanata.ca.astro.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807031118590.2010@capitanata.ca.astro.it>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >This seems very odd though, Giacomo, are you sure it 
> >also happens if you
> >unload the module?
> 
> yes, absolutely (unfortunately). I can unload the module 
> before suspending,
> reload it after resuming, same result; I can actually do 
> any number of
> suspend/resumes, unload and reload the modules any 
> number of times,
> everything still works until I try to ifconfig up the 
> interface, then it
> hangs solid. 

That starts to sound like some core problem -- bug in b43 does not
explain symptoms you see. What other drivers does b43 share interrupt
with? Do those work after resume? Maybe irqpoll helps?

> I am now compining a kernel with the patch you sent, to 
> see whether this
> improves things. I will let you know. By the way, is 
> there a module
> debugging option I could use to cause the b43 and/or 
> mac80211 modules to use
> lots of printk's, so that I could at least give you a 
> hint as to where the
> code hangs?

Adding printks to b43's resume should be easy...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

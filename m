Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbYDBWZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbYDBWZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758385AbYDBWZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:25:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:32954 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbYDBWZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:25:12 -0400
Date: Thu, 3 Apr 2008 00:25:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's the incompatibility between hibernation and
	hotplug?memory
Message-ID: <20080402222555.GF4644@elf.ucw.cz>
References: <47EAD9A7.6020609@goop.org> <200803272155.01463.rjw@sisk.pl> <20080327233852.GA32617@elf.ucw.cz> <200803280044.00982.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803280044.00982.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-03-28 00:44:00, Rafael J. Wysocki wrote:
> On Friday, 28 of March 2008, Pavel Machek wrote:
> > On Thu 2008-03-27 21:55:01, Rafael J. Wysocki wrote:
> > > On Thursday, 27 of March 2008, Jeremy Fitzhardinge wrote:
> > > > Pavel Machek wrote:
> > > > > Hi!
> > > > >
> > > > >   
> > > > >>> I noticed that Kconfig warns that hibernation and hotplug memory are not 
> > > > >>> compatible.  What's the issue?
> > > > >>>       
> > > > >> Generally, we might not be able to handle memory unplugged at a wrong time
> > > > >> (eg. after we've created the image).
> > > > >>
> > > > >> Which part of Kconfig says that exactly?
> > > > >>     
> > > > >
> > > > > Actually I believe it is simpler than that. We were not prepared to
> > > > > deal with memory holes in hibernation code, so we just disabled it in
> > > > > Kconfig...
> > > > 
> > > > Doesn't that mean its generally incompatible with non-flatmem memory 
> > > > arrangements rather than hotplug memory specifically?
> > > 
> > > No, it should work with NUMA nowadays, actually.
> > > 
> > > Perhaps it's worth trying it with hotplug memory and see what problems arise?
> > 
> > Good. I believe it is good chance it will work with hotplug, too... as
> > long as memory is not inserted/removed during suspend/resume.
> 
> Well, there may be a problem if it's inserted after we've created the image
> and before powering off, because the resumed kernel will not have any idea of
> the new memory.  It probably will require us to add some resume callbacks
> for the memory hotplugging to handle this cleanly.

Well, "not having any idea of new memory" should not lead to big
problems. 

"Not being aware that memory was removed" would be worse ;-).

And I think that we have the ammount of memory check, and will refuse
the resume which is good failsafe behaviour.

...so someone interested should just test it ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

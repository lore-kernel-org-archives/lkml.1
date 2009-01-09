Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbZAIWWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbZAIWWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932080AbZAIWVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:21:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60926 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761AbZAIWVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:21:43 -0500
Date: Fri, 9 Jan 2009 23:23:43 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Frans Pop <elendil@planet.nl>,
       oliver@neukum.org, gregkh@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       torvalds@linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [Regression] USB wakeup problem on Toshiba Portege R500
Message-ID: <20090109222343.GA2223@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0901091055050.10951-100000@netrider.rowland.org> <200901091853.42700.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901091853.42700.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-09 18:53:41, Rafael J. Wysocki wrote:
> [CCing ACPI and Len)
> 
> On Friday 09 January 2009, Alan Stern wrote:
> > On Thu, 8 Jan 2009, Frans Pop wrote:
> > 
> > > Rafael J. Wysocki wrote:
> > > > On Thursday 08 January 2009, Oliver Neukum wrote:
> > > >> Am Thursday 08 January 2009 17:36:12 schrieb Rafael J. Wysocki:
> > > >> You are making a very persuasive argument for reverting it.
> > > >> But what about laptops that only have a USB keyboard?
> > > > 
> > > > Well, up to and including 2.6.28 they needed to echo 'enable' to the USB
> > > > controllers' /sys/devices/.../power/wakeup files, so if the patch is
> > > > reverted, they won't be worse off than they were day before
> > > > yesterday. :-) 
> > > > 
> > > > Perhaps we can choose the default depending on whether or not any HID
> > > > devices are attached to given controller?
> > > 
> > > Is "resume on keyboard activity" really all that needed? Both my laptops 
> > > and my desktop resume fine after pressing the power button.
> > > 
> > > Also consider the following cases:
> > > - laptop has been suspended with external USB mouse connected
> > >   - mouse is moved (accidentally or because it is in the way of a coffee
> > >     cup)
> > >   - mouse cable is removed before putting the laptop in a bag for
> > >     transport
> > > - laptop is in docking station with USB mouse/kbd connected to that
> > >   - again, mouse gets moved for some reason
> > >   - laptop is undocked while suspended
> > >   - or the reverse: laptop gets docked
> > > 
> > > IMO it is not desirable that the system gets resumed as a result of any of 
> > > those actions. I'm not complete sure that it would in all those cases, 
> > > but have they been considered?
> > > 
> > > And in general I've always been in favor of things only happening 
> > > automagically if I've explicitly asked for that, and not by default.
> > 
> > I don't mind reverting the "automatically enable PCI wakeup" commit.  But 
> > we should first come to a definite policy for kernel default wakeup 
> > settings, rather than deciding things piecemeal for different subsystems.
> > 
> > My proposal:
> > 
> > 	Devices and events that are clearly associated with system
> > 	wakeup should be enabled by default.  For example: Power
> > 	button and laptop lid.
> 
> Agreed.
> 
> > 	All other devices capable of waking up the system should be
> > 	disabled by default.  This presumably includes every PCI
> > 	device.  If users want keyboard or mouse events to cause
> > 	a system resume then they will have to configure their
> > 	desktop management program to enable it.
> 
> I generally agree, with one exception.  There are network adapters which
> can be enabled to wake up by the BIOS and their drivers set them up for WoL
> currently on this basis.  These should remain enabled IMO.

Agreed. WoL worked before and it should remain working.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

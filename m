Return-Path: <linux-kernel-owner+w=401wt.eu-S1764308AbXJZQvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764308AbXJZQvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbXJZQv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:51:26 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:47123 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbXJZQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:51:25 -0400
Date: Fri, 26 Oct 2007 18:54:00 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20071026165400.GA19019@enneenne.com>
References: <20071026105125.GA28769@enneenne.com> <20071026151141.GA4321@flint.arm.linux.org.uk> <20071026154705.GY19019@enneenne.com> <20071026160206.GC4321@flint.arm.linux.org.uk> <20071026162705.GZ19019@enneenne.com> <20071026163651.GD4321@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026163651.GD4321@flint.arm.linux.org.uk>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] PCMCIA: prevent auto insert during resume.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 05:36:51PM +0100, Russell King wrote:
> On Fri, Oct 26, 2007 at 06:27:06PM +0200, Rodolfo Giometti wrote:
> > On Fri, Oct 26, 2007 at 05:02:06PM +0100, Russell King wrote:
> > > When you bring the battery device out of resume, and you've inserted a
> > > card, you want it to be detected.  Your change means you have to wait
> > > until the system has finished resuming before you plug the card in,
> > > which practically is a pain in the butt and actually leads to user
> > > errors.  IOW:
> > > 
> > > "I plugged my wireless card in after I pressed the power button, why
> > > wasn't it detected?"
> > 
> > My patch doesn't affect the power on sequence, just the resume
> > one.
> 
> On a lot of devices, the "power button" is the resume button.  When you
> "turn it off" it suspends, and when you "turn it on" it resumes.

I see. My device has two buttons.

However even in this case, if you never eject the device, then switch
off (sleep), change the device into the slot and then power on (wake
up), with my patch everything continues to work as before.

The differences come up only if you eject the device before power off.

> > Also if you didn't eject the socket, at resume the device will be
> > powered up again, my patch just prevents that a pre-powered off device
> > to be turned on at resume time.
> > 
> > However you should consider that some embedded systems have fixed
> > PCMCIA devices that can't be removed so there are no reasons to detect
> > them after resume, nobody can change them. :)
> > 
> > Also battery powered devices can go very frequently to sleep and the
> > current behavior force the user to switch off the unused device each
> > time the system resumes from sleep.
> 
> I realise that.  I do work on embedded devices, and this behaviour is
> explicitly there to support embedded devices.
> 
> I've suggested a workable solution to you which allows both of us to
> have the behaviour we both desire from the system.  That sounds like
> a negotiated solution to me...

Do you mean to switch off the socket from userland? It could be a
solution but in this case the device is powered on each time even if
for a short delay...

Maybe we can add an entry into sysfs? Or just a module parameter? So
developers can choose their preferred behaviour. :)

Thanks for your time,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127

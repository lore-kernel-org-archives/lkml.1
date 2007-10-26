Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbXJZQYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbXJZQYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbXJZQYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:24:34 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:46947 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbXJZQYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:24:33 -0400
Date: Fri, 26 Oct 2007 18:27:06 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20071026162705.GZ19019@enneenne.com>
References: <20071026105125.GA28769@enneenne.com> <20071026151141.GA4321@flint.arm.linux.org.uk> <20071026154705.GY19019@enneenne.com> <20071026160206.GC4321@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026160206.GC4321@flint.arm.linux.org.uk>
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

On Fri, Oct 26, 2007 at 05:02:06PM +0100, Russell King wrote:
> 
> Not on a battery powered device with a graphical interface.

This can be done by a button, menu or other graphical object. :)

> > On battery powered device I should prevent power lost, so if I power
> > down a device I'd like it should remain off even after resume.
> 
> In which case you need to remember why it was powered down and act
> accordingly.

Yes. This have some reasons... for example, my custom board has a WiFi
connected to the PCMCIA interface (which consumes a lot of power) and
if the user switch off the WiFi I think he/she doesn't wish the WiFi
is automagic powered on after resume... this behaviour can cause power
lost if the user forgot to switch it off again.

> > Why the system should power it on automagically? Just for detection?
> 
> When you bring the battery device out of resume, and you've inserted a
> card, you want it to be detected.  Your change means you have to wait
> until the system has finished resuming before you plug the card in,
> which practically is a pain in the butt and actually leads to user
> errors.  IOW:
> 
> "I plugged my wireless card in after I pressed the power button, why
> wasn't it detected?"

My patch doesn't affect the power on sequence, just the resume
one. Also if you didn't eject the socket, at resume the device will be
powered up again, my patch just prevents that a pre-powered off device
to be turned on at resume time.

However you should consider that some embedded systems have fixed
PCMCIA devices that can't be removed so there are no reasons to detect
them after resume, nobody can change them. :)

Also battery powered devices can go very frequently to sleep and the
current behavior force the user to switch off the unused device each
time the system resumes from sleep.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127

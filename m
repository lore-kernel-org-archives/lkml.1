Return-Path: <linux-kernel-owner+w=401wt.eu-S1751476AbZCHI3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbZCHI3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 04:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbZCHI3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 04:29:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51218 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZCHI3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 04:29:11 -0400
Date: Sun, 8 Mar 2009 09:29:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net
Subject: Re: introduce delayed-leds.h to reduce code duplication
Message-ID: <20090308082902.GC1371@ucw.cz>
References: <20090111224331.GA28010@elf.ucw.cz> <20090112100500.GA31656@khazad-dum.debian.net> <20090119150219.GA6463@ucw.cz> <20090120120400.GA15144@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120120400.GA15144@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-20 10:04:00, Henrique de Moraes Holschuh wrote:
> On Mon, 19 Jan 2009, Pavel Machek wrote:
> > On Mon 2009-01-12 08:05:01, Henrique de Moraes Holschuh wrote:
> > > On Sun, 11 Jan 2009, Pavel Machek wrote:
> > > > What about something like this? 
> > > > 
> > > > [Alternatively, I can add a flag to the leds class, and make delayed
> > > > leds a built-in functionality...]
> > > > 
> > > > [Attached is driver that uses new infrastructure for hp_accel, but it
> > > > does a bit more.]
> > > 
> > > FWIW, I am looking over the thinkpad-acpi side of this.  I like the idea,
> > > but I am not completely sure I agree fully with the changes to
> > > thinkpad-acpi.
> > > 
> > > Which isn't a problem, as long as the thinkpad-acpi hunks are NOT merged to
> > > any tree before my ACK, please.  I will test and comment on the patch before
> > > the weekend.
> > 
> > Any news?
> 
> Sure.  Sorry for not replying earlier.
> 
> I don't like the loss of functionality of the private workqueue.  I kicked
> the thinkpad led handling to a private workqueue in order to never tie up
> the system-wide one with crap spinning around in the ACPI layer, etc.  In
> fact, all thinkpad-acpi deferred work is in the private workqueue for this
> reason.

Is the private workqueue really required? AFAICT workqueues are not
exactly cheap, and leds are not toggled that often. Was it problem in
practice?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

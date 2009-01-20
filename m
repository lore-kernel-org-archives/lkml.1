Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbZATMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbZATMES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZATMEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:04:07 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35995 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440AbZATMEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:04:06 -0500
X-Sasl-enc: tQ8q9tmurQWI4EfCxxfNhK/SHhFdCr8seudLdZdFpQoV 1232453043
Date: Tue, 20 Jan 2009 10:04:00 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net
Subject: Re: introduce delayed-leds.h to reduce code duplication
Message-ID: <20090120120400.GA15144@khazad-dum.debian.net>
References: <20090111224331.GA28010@elf.ucw.cz> <20090112100500.GA31656@khazad-dum.debian.net> <20090119150219.GA6463@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119150219.GA6463@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009, Pavel Machek wrote:
> On Mon 2009-01-12 08:05:01, Henrique de Moraes Holschuh wrote:
> > On Sun, 11 Jan 2009, Pavel Machek wrote:
> > > What about something like this? 
> > > 
> > > [Alternatively, I can add a flag to the leds class, and make delayed
> > > leds a built-in functionality...]
> > > 
> > > [Attached is driver that uses new infrastructure for hp_accel, but it
> > > does a bit more.]
> > 
> > FWIW, I am looking over the thinkpad-acpi side of this.  I like the idea,
> > but I am not completely sure I agree fully with the changes to
> > thinkpad-acpi.
> > 
> > Which isn't a problem, as long as the thinkpad-acpi hunks are NOT merged to
> > any tree before my ACK, please.  I will test and comment on the patch before
> > the weekend.
> 
> Any news?

Sure.  Sorry for not replying earlier.

I don't like the loss of functionality of the private workqueue.  I kicked
the thinkpad led handling to a private workqueue in order to never tie up
the system-wide one with crap spinning around in the ACPI layer, etc.  In
fact, all thinkpad-acpi deferred work is in the private workqueue for this
reason.

This is easy enough to fix, you just need to provide both versions of the
interface (standard workqueue, and private workqueue).  OTOH, if nowadays
the system-wide workqueue runs tasks in parallel and there is no risk of a
task blocking others from completely unrelated subsystems, I can ditch the
private workqueue.

Also, if it is going to be generic, I'd suggest the usual "void *data"
opaque type to carry information for the driver, instead of a "led number".

I didn't see any comments from Richard, but your comment about a flag seems
to imply there was a private one?  IMHO enhancing the led class would be the
best way to go about it, although deferred leds are simple enough that it
doesn't matter much.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

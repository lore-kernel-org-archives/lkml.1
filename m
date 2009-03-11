Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZCKBjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZCKBjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZCKBjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:39:12 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33659 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbZCKBjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:39:11 -0400
X-Sasl-enc: /DCK9/5Iw7RNUk+xV6HxunQ7/wIl0T/tdpUNFHlUvMYO 1236735549
Date: Tue, 10 Mar 2009 22:39:06 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net
Subject: Re: introduce delayed-leds.h to reduce code duplication
Message-ID: <20090311013906.GA8637@khazad-dum.debian.net>
References: <20090111224331.GA28010@elf.ucw.cz> <20090112100500.GA31656@khazad-dum.debian.net> <20090119150219.GA6463@ucw.cz> <20090120120400.GA15144@khazad-dum.debian.net> <20090308082902.GC1371@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308082902.GC1371@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Mar 2009, Pavel Machek wrote:
> On Tue 2009-01-20 10:04:00, Henrique de Moraes Holschuh wrote:
> > On Mon, 19 Jan 2009, Pavel Machek wrote:
> > > On Mon 2009-01-12 08:05:01, Henrique de Moraes Holschuh wrote:
> > > > On Sun, 11 Jan 2009, Pavel Machek wrote:
> > > > > What about something like this? 
> > > > > 
> > > > > [Alternatively, I can add a flag to the leds class, and make delayed
> > > > > leds a built-in functionality...]
> > > > > 
> > > > > [Attached is driver that uses new infrastructure for hp_accel, but it
> > > > > does a bit more.]
> > > > 
> > > > FWIW, I am looking over the thinkpad-acpi side of this.  I like the idea,
> > > > but I am not completely sure I agree fully with the changes to
> > > > thinkpad-acpi.
> > > > 
> > > > Which isn't a problem, as long as the thinkpad-acpi hunks are NOT merged to
> > > > any tree before my ACK, please.  I will test and comment on the patch before
> > > > the weekend.
> > > 
> > > Any news?
> > 
> > Sure.  Sorry for not replying earlier.
> > 
> > I don't like the loss of functionality of the private workqueue.  I kicked
> > the thinkpad led handling to a private workqueue in order to never tie up
> > the system-wide one with crap spinning around in the ACPI layer, etc.  In
> > fact, all thinkpad-acpi deferred work is in the private workqueue for this
> > reason.
> 
> Is the private workqueue really required? AFAICT workqueues are not
> exactly cheap, and leds are not toggled that often. Was it problem in
> practice?

Well, the day we can trust the main workqueue not to block or delay
important stuff, I will use it.  Until then, I feel it is best to have
thinkpad-acpi work scheduled independently from the important stuff.

The private workqueue is NOT used just for the LEDs, it is used for
every thinkpad-acpi deferred-work needs.  And I'd rather the thinkpad-acpi
LED work didn't move to the main workqueue.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

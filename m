Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbXFKPSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbXFKPSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbXFKPSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:18:09 -0400
Received: from sccrmhc13.comcast.net ([204.127.200.83]:34644 "EHLO
	sccrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbXFKPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:18:07 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2007 11:18:07 EDT
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeremy Maitin-Shepard <jmaitins@andrew.cmu.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: A kexec approach to hibernation
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	<87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl>
	<87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz>
	<20070604220910.GB2515@andrew.cmu.edu> <20070604225143.GF2711@elf.ucw.cz>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 11 Jun 2007 11:07:54 -0400
In-Reply-To: <20070604225143.GF2711@elf.ucw.cz> (Pavel Machek's message of
	"Tue\, 5 Jun 2007 00\:51\:43 +0200")
Message-ID: <87zm36msvp.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

[snip]

>> > If _I_ were willing to add some runtime overhead to make hibernation
>> > simpler, I'd just use some virtualization to do that... with added
>> > advantage of "hibernate here, resume on different hw".
>> 
>> I don't believe there is going to be any runtime overhead.

> 64MB less memory seems like runtime overhead for me. If you know how
> to do kexec without pre-reserving memory, I believe kexec/kdump team
> will be interested.

The main reason kdump needs to reserve memory at boot is that it needs
to preload the crashdump kernel into memory so that it will be available
on panic (and however much memory the crashdump kernel will need to run
will also need to be available at all times, since a panic can occur at
any time), and also because no attempt is made to shutdown devices on
panic, and consequently devices may clobber existing memory with ongoing
DMA, so a reserved area of memory must be used by the crashdump kernel.

For hibernate via kexec, however, these issues do not exist.  The
simplest solution would be to simply backup the first say 16MB or 64MB
(or however much is desired for the "save" kernel to have) of memory
into free pages just before copying the "save" kernel into the desired
position and jumping to it.

Due to the speed of memory copying, this should not add any significant
overhead.

[snip]

-- 
Jeremy Maitin-Shepard

Return-Path: <linux-kernel-owner+w=401wt.eu-S932721AbXBKX34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbXBKX34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932825AbXBKX34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:29:56 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:40133 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbXBKX3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:29:55 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070211232105.GG15445@elf.ucw.cz>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl>
	 <20070211194202.GC15445@elf.ucw.cz>
	 <20070211210258.0b8da53c@localhost.localdomain>
	 <1171235428.4493.105.camel@nigel.suspend2.net>
	 <20070211232105.GG15445@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 10:29:54 +1100
Message-Id: <1171236594.4493.127.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-12 at 00:21 +0100, Pavel Machek wrote:
> Hi!
> 
> > > > > define .suspend that will always return -ENOSYS (then people will know they
> > > > > have to unload the driver before the suspend).  Similarly, if you aren't sure
> > > > > whether or not the device requires .suspend and .resume, define .suspend that
> > > > > will always return -ENOSYS."
> > > > 
> > > > Sounds ok to me. Where should this text go?
> > > > Documentation/SubmittingDrivers ?
> > > 
> > > And testing/submitting drivers, perhaps with additional text in that to
> > > make it clear we want suspend/resume support or good excuses
> > > 
> > > "Please verify your driver correctly handles suspend and resume. If it
> > > does not your patch submission is likely to be suspended and only resume
> > > when the driver correctly handles this feature"
> > 
> > Maybe make it explicit that testing should be done for both suspend to
> > ram and to disk, and with the following usage scenarios as
>  > applicable?
> 
> Well, for many people s2ram does not work even today... so requiring
> them to test it is slightly draconian.
> 
> > - built in;
> > - modular, loaded while suspending but not loaded prior to resume from
> > disk;
> 
> These two should be equivalent.

No. The differences are:

Built in: The initcalls will have run, but the driver may or may not
actually have been used, depending on whether it's used before we start
the resume. It should probably be tested with both having been used and
not having been used.
Modular, loaded prior to suspending but not prior to resuming: At resume
time, will still be in whatever config the bios puts it in. No Linux
driver code will have touched it.
Modular, loaded prior to suspending and resuming: Should be equivalent
to built in (module initcalls will have run), but may vary if there's
some difference in code/timing between being a module and built in.
(This shouldn't happen, but that's the point to testing).

> > - modular, loaded while suspending and loaded prior to resume from disk;
> 
> Ok.. but I'm not sure how many people will actually test it _that_
> thoroughly. "Try to test it" is good enough for a first version. When
> suspend is in better shape, we can ask for more.

I'd prefer to ask for what should be done from the start. Will we expect
people to go back and retest if we change the rules, or do we prefer
them to complain "You didn't adequately point out the testing I needed
to do, and I got all these complaints from my users!"

Regards,

Nigel


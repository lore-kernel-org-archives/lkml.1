Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbXE1K7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbXE1K7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750700AbXE1K73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:59:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44533 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750699AbXE1K72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:59:28 -0400
Date: Mon, 28 May 2007 12:58:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1 Implementing fan/thermal control in userspace - Was: [cannot change thermal trip points]
Message-ID: <20070528105851.GE18807@elf.ucw.cz>
References: <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz> <20070522003153.GA18162@srcf.ucam.org> <1180016213.16396.74.camel@queen.suse.de> <20070524143644.GA27364@srcf.ucam.org> <20070525063815.GA3989@ucw.cz> <20070527215123.GA22687@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070527215123.GA22687@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Because, as Len has pointed out, you end up with two different ideas 
> > > about what the trip points are - the kernel's and the hardware's. That 
> > > works fine until some event in the firmware either forcibly 
> > > resynchronises the two or makes assumptions about the spec-compliance of 
> > > the interpreter.
> > 
> > ...and suggested workaround is to drive fans directly from userspace,
> > which not only violates the specs and has all the problems with
> > desynchronized state, but ALSO FAILS TO WORK IN PRACTICE.
> 
> I don't think that's obviously true. 11.3.2 of the 3.0 spec states:

> "A package consisting of references to all active cooling devices that 
> should be engaged when the associated active cooling threshold (_ACx) is 
> exceeded." 

We'd need:

a) way to tell acpi not to control fans any more

b) in kernel watchdog so that acpi starts controlling fans after oom
killer

c) way to control passive cooling from userspace.

Not something doable for 2.6.22.  


> > > The interface would need to be more complicated than that if you wanted 
> > > to be able to implement hysteresis, and there's the potential for 
> > > hardware damage if paramaters are set inappropriately. Even then, 
> > > there's no easy way of programatically determining whether it would work 
> > > on any given hardware.
> > 
> > Not sure why you try to scare people with 'hardware damage'. HP XE3
> > bios already _was_ damaging hardware (it cooked the hard drive using
> > cpu as a heater), and no acpi magic can damage correctly working
> > machine.
> 
> Given that this presumably didn't occur under Windows, I think it would
> be significantly better to figure out why and then fix that. 

It would happily occur under Windows. You just needed to load machine
in a way that cpu stayed ~80C.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

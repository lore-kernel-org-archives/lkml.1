Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYGHIOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYGHIOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYGHIOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:14:16 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:4503 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYGHIOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:14:14 -0400
X-Greylist: delayed 688 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jul 2008 04:14:14 EDT
Date: Tue, 8 Jul 2008 10:02:41 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bruno.premont@restena.lu>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: Pavel Machek <pavel@suse.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080708100241.36b89e20@pluto.restena.lu>
In-Reply-To: <20080708072152.GD1761@elf.ucw.cz>
References: <20080623160052.GA7616@ldl.fc.hp.com>
	<20080627191458.GA10872@ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net>
	<20080707160658.GB1794@elf.ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
	<20080708072152.GD1761@elf.ucw.cz>
Organization: Fondation RESTENA
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 09:21:52 +0200 Pavel Machek <pavel@suse.cz> wrote:
> On Mon 2008-07-07 17:37:18, Altobelli, David wrote:
> > Pavel Machek wrote:
> > > Hi!
> > >
> > >>>> A driver for the HP iLO/iLO2 management processor, which allows
> > >>>> userspace programs to query the management processor. Programs
> > >>>> can open a channel to the device (/dev/hpilo/dXccbN), and use
> > >>>> this to send/receive queries.
> > >>>
> > >>> What kind of queries? Is there documentation somewhere?
> > >>
> > >> Generally, it can get data out of the management processor -
> > >> things like basic iLO configuration (users, nic, etc), handle
> > >> SNMP traffic, flashing iLO, and some others.
> > >>
> > >> Unfortunately, there isn't yet any available documenation.
> > >
> > > Ok, I guess we should have documentation "what does it do" and
> > > "what protocol does it speak" before we can think about merging.
> > 
> > I really hope that isn't the case.
> 
> Telling us "what does it do" seems like good start.
> 
> > However, I do think there is value in merging the driver without
> > docs. Having drivers in tree is often stated as a goal, because of
> > the obvious security and API/ABI disadvantages to out of tree
> > drivers.
> 
> You know, we'd prefer to have kernel<->user ABI documented. With this
> driver... we don't.
> 
> What does /dev/hpilo/* do? Beep speakers? Control fans? Launch atomic
> bombs? What will happen on cat /bin/bash > /dev/hpilo/dXccbN? Does
> that depend on concrete machine? Is it acceptable for this
> functionality not to be abstracted out? (Kernel should provide hw
> abstraction, right?)

If the driver allows access to hardware monitoring features available
via iLO/iLO2 (fan, temperature, voltage) it would be really useful if
this driver also registered the sensors with hwmon framework so the
details are accessible via lm_sensors. (like is now done for ACPI
thermal zone)
Same applies for any information that could be properly mapped to
other existing frameworks (e.g. power supply class)

> > If this can't be merged, then we continue to ship an out of tree
> > driver, which no one (us, distros, customers) likes.  We pester our
> > partners to support this driver, or include it, or what have you.
> > We get slowly out of date, and bugs creep in, or our package breaks
> > on upstream kernels. To me, it seems like merging the driver is the
> > better path.
> 
> Docs for kernel<->user ABI does not seem like too much to ask.
> 
> If you wrote a driver, I don't think it is unreasonable for me to ask
> "how to use that driver".
> 									Pavel

Bruno

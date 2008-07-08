Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbYGHUbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbYGHUbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYGHUbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:31:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33465 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbYGHUbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:31:43 -0400
Date: Tue, 8 Jul 2008 12:37:32 +0200
From: Pavel Machek <pavel@suse.cz>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bruno.premont@restena.lu>
Cc: "Altobelli, David" <david.altobelli@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080708103732.GA15317@elf.ucw.cz>
References: <20080623160052.GA7616@ldl.fc.hp.com> <20080627191458.GA10872@ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net> <20080707160658.GB1794@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net> <20080708072152.GD1761@elf.ucw.cz> <20080708100241.36b89e20@pluto.restena.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080708100241.36b89e20@pluto.restena.lu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-07-08 10:02:41, Bruno Prémont wrote:
> On Tue, 8 Jul 2008 09:21:52 +0200 Pavel Machek <pavel@suse.cz> wrote:
> > On Mon 2008-07-07 17:37:18, Altobelli, David wrote:
> > > Pavel Machek wrote:
> > > > Hi!
> > > >
> > > >>>> A driver for the HP iLO/iLO2 management processor, which allows
> > > >>>> userspace programs to query the management processor. Programs
> > > >>>> can open a channel to the device (/dev/hpilo/dXccbN), and use
> > > >>>> this to send/receive queries.
> > > >>>
> > > >>> What kind of queries? Is there documentation somewhere?
> > > >>
> > > >> Generally, it can get data out of the management processor -
> > > >> things like basic iLO configuration (users, nic, etc), handle
> > > >> SNMP traffic, flashing iLO, and some others.
> > > >>
> > > >> Unfortunately, there isn't yet any available documenation.
> > > >
> > > > Ok, I guess we should have documentation "what does it do" and
> > > > "what protocol does it speak" before we can think about merging.
> > > 
> > > I really hope that isn't the case.
> > 
> > Telling us "what does it do" seems like good start.
> > 
> > > However, I do think there is value in merging the driver without
> > > docs. Having drivers in tree is often stated as a goal, because of
> > > the obvious security and API/ABI disadvantages to out of tree
> > > drivers.
> > 
> > You know, we'd prefer to have kernel<->user ABI documented. With this
> > driver... we don't.
> > 
> > What does /dev/hpilo/* do? Beep speakers? Control fans? Launch atomic
> > bombs? What will happen on cat /bin/bash > /dev/hpilo/dXccbN? Does
> > that depend on concrete machine? Is it acceptable for this
> > functionality not to be abstracted out? (Kernel should provide hw
> > abstraction, right?)
> 
> If the driver allows access to hardware monitoring features available
> via iLO/iLO2 (fan, temperature, voltage) it would be really useful if
> this driver also registered the sensors with hwmon framework so the
> details are accessible via lm_sensors. (like is now done for ACPI
> thermal zone)
> Same applies for any information that could be properly mapped to
> other existing frameworks (e.g. power supply class)

Yes.. and other stuff it can do should be exported in "reasonable"
form, like /sys interface where it makes sense.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

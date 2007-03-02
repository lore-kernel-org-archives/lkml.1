Return-Path: <linux-kernel-owner+w=401wt.eu-S933345AbXCBLki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbXCBLki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXCBLki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:40:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46964 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933336AbXCBLkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:40:37 -0500
Date: Fri, 2 Mar 2007 12:40:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Rudolf Marek <r.marek@assembler.cz>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070302114023.GD2163@elf.ucw.cz>
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301152655.f232db64.khali@linux-fr.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Well I had an idea after looking at k8temp -- why not make it default to
> > > > doing only reads from the sensor?  You'd only get information from whatever
> > > > core/sensor combination that ACPI had last used, but it would be safe.
> > > 
> > > ACPI is broken here, not k8temp, so let's fix ACPI instead. ACPI
> > > doesn't conflict with only k8temp, but with virtually all hardware
> > > monitoring drivers, all I2C/SMBus drivers, and probably other types of
> > > drivers too. We just can't restrict or blacklist all these drivers
> > > because ACPI misbehaves.
> > 
> > Oops, sorry about that but no, that will not work.
> > 
> > There's piece of paper, called ACPI specification, and we are
> > following it.
> 
> I never suggested otherwise. But the Linux 2.6 device driver model is
> based, in part, on the fact that each driver must request the
> resources it needs before actually using them. The acpi subsystem fails
> to do that, so it is, in that sense, misbehaving. The is the root cause
> of the problems people are reporting these days.

Ok. You are right that ACPI is an ugly piece of mess. But I'm pretty
sure that 90%+ of ACPI notebook implementations *will* want to talk to
their monitoring chips... for temperature readings.

So even if we fixed ACPI to reserve the ports, you'd be still unhappy;
lm-sensors would break at least on all the notebooks.

> > Now, you may try to change specs to be hwmon-friendly... good luck.
> 
> I would like them to be driver-model-friendly, that's even a broader
> challenge ;)

:-).

> > But currently hw manufacturers follow ACPI specs, so we have to follow
> > it, too; bad luck for hwmon. BIOS hiding smbus from you is good hint
> > you are doing something wrong...?
> 
> I would love things to be that easy, but unfortunately they are not.
> 
> Firstly, the first records of hidden SMBus, in September 2000, predate
> ACPI. All the early boards where the SMBus was hidden did not have ACPI
> code poking at it at all, so this is definitely not the reason why it
> was removed. The Asus P4 series is a good example of that. Unhiding the
> SMBus on these boards actually let the user take benefit of the
> hardware they had paid for.

...against wishes of the manufacturers. Which sometimes know what they
are doing. (Sometimes not :-).

> I would be happy to prevent SMBus and/or hardware monitoring drivers
> from being loaded on ACPI-based system if we had a way to know which
> systems do have ACPI code accessing these chips and which do not, and if
> ACPI was offering a level of functionality comparable to what
> individual hardware monitoring drivers offer. Unfortunately:

Well, I'm afraid you should assume all recent notebooks touch sensors
from ACPI.

> 1* As far as I know, we currently have no way to know if the ACPI code
> plans to ever access the hardware monitoring chip. If the acpi
> subsystem could export this information somehow, it would help a lot.
> But I'm not familiar with ACPI, so I don't know if this is feasable or
> not. We just can't prevent the SMBus and hardware monitoring drivers
> drivers from being loaded as soon as ACPI is enabled. This would
> prevent a majority of users from using them, while they work fine for
> most of them.

What about whitelist? DMI-based? That's only way to do it, I'm afraid.

> 2* The hardware monitoring features offered by ACPI today are one level
> of magnitude weaker than what lm_sensors was already offering back in
> 1999. The monitoring chips can do much but unfortunately ACPI only
> exposes a very small subset of the chip features. ACPI doesn't
> handle

Yes, I know ACPI sucks at hardware monitoring. Unfortunately, we can't
go without ACPI.

> voltage monitoring at all. It usually reports no more than one fan, and
> in my experience, more often than not, the speed is reported as a
> boolean (spinning or not), when lm_sensors gives you the exact speed of
> all your fans. ACPI thermal zones are not so bad, but the interface to
> control them is ugly, and lm_sensors usually gives more details. And

Fix the interface? ;-). Actually that move may be underway as we are
moving out of /proc.

> What do you propose?

Whitelist seems like a way to go :(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

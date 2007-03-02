Return-Path: <linux-kernel-owner+w=401wt.eu-S2992483AbXCBOY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992483AbXCBOY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992485AbXCBOY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:24:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48872 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992482AbXCBOYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:24:55 -0500
Date: Fri, 2 Mar 2007 15:24:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Rudolf Marek <r.marek@assembler.cz>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070302142441.GL2156@elf.ucw.cz>
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz> <20070302150313.198b6053.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302150313.198b6053.khali@linux-fr.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok. You are right that ACPI is an ugly piece of mess. But I'm pretty
> > sure that 90%+ of ACPI notebook implementations *will* want to talk to
> > their monitoring chips... for temperature readings.
> >
> > So even if we fixed ACPI to reserve the ports, you'd be still unhappy;
> > lm-sensors would break at least on all the notebooks.
> 
> That's a secondary problem. The primary issue is the concurrent access
> to resources, which cause lots of trouble which are hard to investigate.
> If ACPI reserves the ports, then the SMBus or hardware monitoring
> drivers (or any other conflicting driver) will cleanly fail to load,
> which would be a move in the right direction. Ideally we would be able
> to synchronize the accesses between ACPI and the other drivers, but if
> we can't, I'd already be _very happy_ to just prevent conflicting
> drivers from being loaded at the same time.
> 
> So, can ACPI actually reserve the ports it accesses?

No idea, talk to Len Brown (or start reading the code) :-(. I don't
think it will be easy.

> > > 1* As far as I know, we currently have no way to know if the ACPI code
> > > plans to ever access the hardware monitoring chip. If the acpi
> > > subsystem could export this information somehow, it would help a lot.
> > > But I'm not familiar with ACPI, so I don't know if this is feasable or
> > > not. We just can't prevent the SMBus and hardware monitoring drivers
> > > drivers from being loaded as soon as ACPI is enabled. This would
> > > prevent a majority of users from using them, while they work fine for
> > > most of them.
> > 
> > What about whitelist? DMI-based? That's only way to do it, I'm afraid.
> 
> What kind of whitelist do you have in mind? We can't realistically
> maintain an ever-growing whitelist of hundreds of entries in the
> kernel. We could block all laptops by default and maintain a white list
> only for them, and a black list for other systems, the would probably
> limit the maintenance work, maybe not to an acceptable level though.

I'm afraid something like that is way to go.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

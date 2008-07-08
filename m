Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYGHHhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYGHHhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYGHHh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:37:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39450 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYGHHhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:37:25 -0400
Date: Tue, 8 Jul 2008 09:38:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080708073818.GA14245@elf.ucw.cz>
References: <20080623160052.GA7616@ldl.fc.hp.com> <20080627191458.GA10872@ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net> <20080707160658.GB1794@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net> <20080708072152.GD1761@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708072152.GD1761@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-07-08 09:21:52, Pavel Machek wrote:
> On Mon 2008-07-07 17:37:18, Altobelli, David wrote:
> > Pavel Machek wrote:
> > > Hi!
> > >
> > >>>> A driver for the HP iLO/iLO2 management processor, which allows
> > >>>> userspace programs to query the management processor. Programs can
> > >>>> open a channel to the device (/dev/hpilo/dXccbN), and use this to
> > >>>> send/receive queries.
> > >>>
> > >>> What kind of queries? Is there documentation somewhere?
> > >>
> > >> Generally, it can get data out of the management processor - things
> > >> like basic iLO configuration (users, nic, etc), handle SNMP traffic,
> > >> flashing iLO, and some others.
> > >>
> > >> Unfortunately, there isn't yet any available documenation.
> > >
> > > Ok, I guess we should have documentation "what does it do" and "what
> > > protocol does it speak" before we can think about merging.
> > 
> > I really hope that isn't the case.
> 
> Telling us "what does it do" seems like good start.
> 
> > However, I do think there is value in merging the driver without docs.
> > Having drivers in tree is often stated as a goal, because of the obvious
> > security and API/ABI disadvantages to out of tree drivers.
> 
> You know, we'd prefer to have kernel<->user ABI documented. With this
> driver... we don't.
> 
> What does /dev/hpilo/* do? Beep speakers? Control fans? Launch atomic
> bombs? What will happen on cat /bin/bash > /dev/hpilo/dXccbN? Does
> that depend on concrete machine? Is it acceptable for this
> functionality not to be abstracted out? (Kernel should provide hw
> abstraction, right?)

It probably does configure passwords on the management processor, for
example?

And for that functionality, something like 

echo new_password > /sys/hpilo/admin/password

would make sense, right? Except that your interface is more like "echo
^%TEWFSGFSDF^%EW&^Tadmin^*&S^F&*SDYF*&SDYF*&YE*Wnew_password(*&DF&S^DF*&DS^F*&S
> /dev/hpilo/d0ccb0", right? (And except that you consider exact
string to echo to change password "proprietary secret").

We'd like to have the first interface, but unfortunately we do not
know enough about hpilo to even ask for better interface.

So we really need the docs here, and then I suspect we need better
kernel<->user interface.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

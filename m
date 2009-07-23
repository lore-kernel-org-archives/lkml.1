Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZGWTNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZGWTNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZGWTNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:13:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44211 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZGWTNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:13:37 -0400
Date: Thu, 23 Jul 2009 21:13:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Subject: Re: Generic events for wake up from S1-S4
Message-ID: <20090723191330.GQ28158@elf.ucw.cz>
References: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com> <20090714235332.GA1552@ucw.cz> <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com> <43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com> <20090718103756.GA11381@elf.ucw.cz> <43e72e890907181302j600506d5oc208167206c44745@mail.gmail.com> <20090718235609.GC25343@khazad-dum.debian.net> <20090723145757.GB28158@elf.ucw.cz> <20090723185720.GB19369@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090723185720.GB19369@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-23 15:57:20, Henrique de Moraes Holschuh wrote:
> On Thu, 23 Jul 2009, Pavel Machek wrote:
> > On Sat 2009-07-18 20:56:10, Henrique de Moraes Holschuh wrote:
> > > On Sat, 18 Jul 2009, Luis R. Rodriguez wrote:
> > > > Hm yeah, but I doubt someone will do that, generally we'd get one wake
> > > > up event. Can't we just report the first one and ignore the rest?
> > > 
> > > Well, I'd say keeping it simple is best, here.  What if you ignore the more
> > > interesting wakeup events by chance (and it is really up to userspace to
> > > know what it considers interesting...)?  IMHO, just issue as many
> > > notifications as needed, let userspace filter it if it wants.
> > > 
> > > But if you guys are talking about something really generic, shouldn't it
> > > also provide the important "why" along with the "who"?
> > > 
> > > Even for the most common cases, the "why" is useful: userspace may well want
> > > to run special routines when it wakes up because of WoL and WoW (instead of
> > > a key press, lid open or mouse movement...).
> > 
> > What special routines?
> 
> Starting a remote maintenance shell is a common usage scenario on corporate
> environments.

But... You want to start maintenance shell not on wakeup from WoL, but
on receiving the magic packet. If you hit the keyboard before to wake
up the machine, and the magic packet still comes, you still want the
remote maintenance shell.

> Besides, it is a generic wakeup notification we're talking about, isn't it?
> I have some that have nothing to do with WoW or WoL:
> 
> 1. Thermal alarm
> 2. Battery alarm
> 3. Hotunplug request (bay/dock): umount stuff, cleanly undock, then go back
> to sleep (optional)

Well, battery&thermal alarms would certainly be useful. (And yes, I
believe it is a bug in ACPI that we don't printk on battery critical).

> > Note that the "why" is unreliable by design. Network driver will
> > ignore WoL during run-time, right?
> 
> "Why" is unrealible?  I don't follow your reasoning.  It should be as
> reliable as "who"...

See above. The wakeup events race with each other.

> If the WoW/WoL device doesn't know why it woke up the system, it uses the
> generic reason for network devices (I don't even know if a network device
> has more than one reason for wakeup).  If a different device wakes the
> system, it might know why and provide that reason.  And if it doesn't know
> it woke up the system, it sends no notification at all.

See above.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

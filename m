Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZGWS52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZGWS52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZGWS51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:57:27 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38290 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbZGWS5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:57:25 -0400
X-Sasl-enc: tlQzfG0RKujYo7zRCE92trQ9o/7EyZ/Cmfwdak5SW9AT 1248375444
Date: Thu, 23 Jul 2009 15:57:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Subject: Re: Generic events for wake up from S1-S4
Message-ID: <20090723185720.GB19369@khazad-dum.debian.net>
References: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com>
 <20090714235332.GA1552@ucw.cz>
 <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com>
 <43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com>
 <20090718103756.GA11381@elf.ucw.cz>
 <43e72e890907181302j600506d5oc208167206c44745@mail.gmail.com>
 <20090718235609.GC25343@khazad-dum.debian.net>
 <20090723145757.GB28158@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090723145757.GB28158@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009, Pavel Machek wrote:
> On Sat 2009-07-18 20:56:10, Henrique de Moraes Holschuh wrote:
> > On Sat, 18 Jul 2009, Luis R. Rodriguez wrote:
> > > Hm yeah, but I doubt someone will do that, generally we'd get one wake
> > > up event. Can't we just report the first one and ignore the rest?
> > 
> > Well, I'd say keeping it simple is best, here.  What if you ignore the more
> > interesting wakeup events by chance (and it is really up to userspace to
> > know what it considers interesting...)?  IMHO, just issue as many
> > notifications as needed, let userspace filter it if it wants.
> > 
> > But if you guys are talking about something really generic, shouldn't it
> > also provide the important "why" along with the "who"?
> > 
> > Even for the most common cases, the "why" is useful: userspace may well want
> > to run special routines when it wakes up because of WoL and WoW (instead of
> > a key press, lid open or mouse movement...).
> 
> What special routines?

Starting a remote maintenance shell is a common usage scenario on corporate
environments.

Besides, it is a generic wakeup notification we're talking about, isn't it?
I have some that have nothing to do with WoW or WoL:

1. Thermal alarm
2. Battery alarm
3. Hotunplug request (bay/dock): umount stuff, cleanly undock, then go back
to sleep (optional)

I already support them in thinkpad-acpi, but all I can do is issue a printk
and set some crap values in sysfs for userspace to query right now (I didn't
want to create yet another non-generic event interface).

> Note that the "why" is unreliable by design. Network driver will
> ignore WoL during run-time, right?

"Why" is unrealible?  I don't follow your reasoning.  It should be as
reliable as "who"...

If the WoW/WoL device doesn't know why it woke up the system, it uses the
generic reason for network devices (I don't even know if a network device
has more than one reason for wakeup).  If a different device wakes the
system, it might know why and provide that reason.  And if it doesn't know
it woke up the system, it sends no notification at all.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

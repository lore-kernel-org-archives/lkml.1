Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZGWUKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZGWUKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 16:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZGWUKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 16:10:54 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47855 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbZGWUKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 16:10:53 -0400
X-Sasl-enc: CRUWAV+/WYzlCEGUVGh6uZX2WDv27wa5xLhZFrsx28xw 1248379853
Date: Thu, 23 Jul 2009 17:10:50 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Subject: Re: Generic events for wake up from S1-S4
Message-ID: <20090723201050.GD19369@khazad-dum.debian.net>
References: <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com>
 <43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com>
 <20090718103756.GA11381@elf.ucw.cz>
 <43e72e890907181302j600506d5oc208167206c44745@mail.gmail.com>
 <20090718235609.GC25343@khazad-dum.debian.net>
 <20090723145757.GB28158@elf.ucw.cz>
 <20090723185720.GB19369@khazad-dum.debian.net>
 <20090723191330.GQ28158@elf.ucw.cz>
 <20090723194522.GC19369@khazad-dum.debian.net>
 <20090723195114.GR28158@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090723195114.GR28158@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009, Pavel Machek wrote:
> On Thu 2009-07-23 16:45:22, Henrique de Moraes Holschuh wrote:
> > On Thu, 23 Jul 2009, Pavel Machek wrote:
> > > > > Note that the "why" is unreliable by design. Network driver will
> > > > > ignore WoL during run-time, right?
> > > > 
> > > > "Why" is unrealible?  I don't follow your reasoning.  It should be as
> > > > reliable as "who"...
> > > 
> > > See above. The wakeup events race with each other.
> > 
> > We deliver them all.  It is that simple.  The rest is up to userspace.
> 
> Ok, but then we should not be talking about wake up events,
> but... events.
> 
> Like "lid opened", "wake packet came", ... . And deliver them even
> when they happen during run-time. That's okay with me.

Well, we *already* deliver "lid opened" when the lid is opened, regardless
of it waking up the computer or not.  But we are missing a way to deliver
other classes of wakeup events.

I know of at least these (incomplete list):

1. network-initiated wakeup
   a. wired
   b. wireless
   c. long-range wireless

2. platform health/condition alarms
   a. battery alarm (two levels, warning and emergency)
   b. thermal alarm (two levels, warning and emergency)
   (we need these as generic alarms, not just reason-for-wakeup)

3. device (or device tree) hotplug/hotunplug
   a. hotunplug request or notification
      (we deliver the request/notification, but we don't know we should
      go back to sleep, so all we are missing is the reason-for-wakeup
      event)

4. management
   a. wake-up/power on clock
   b. remote management command (IMPI, etc)
   c. intrusion alarm
   d. theft alarm

None of those have a standard interface to notify userspace of the reason of
the wake up AFAIK.  Many of these want a generic event interface to be
delivered not just as reason-for-wakeup, but also as runtime events.

And I guess we should also tell userspace what state we are waking up from
(S5 clean state, S5/S4 hibernation, S3), sometimes it matters.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

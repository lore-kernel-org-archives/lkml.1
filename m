Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbYDLSCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbYDLSCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbYDLSCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:02:25 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50164 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754973AbYDLSCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:02:24 -0400
X-Sasl-enc: Z3yy5xRL2Cj/WEf9aR6zrRxhQeNVx0LkaEloPQeMzlwv 1208023342
Date: Sat, 12 Apr 2008 15:02:19 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 3/8] rfkill: handle KEY_RADIO and SW_RADIO events
Message-ID: <20080412180219.GI3402@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-4-git-send-email-hmh@hmh.eng.br> <20080412154711.GA3221@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080412154711.GA3221@anvil.corenet.prv>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Dmitry Torokhov wrote:
> On Fri, Apr 11, 2008 at 05:37:19PM -0300, Henrique de Moraes Holschuh wrote:
> > The *_RADIO input events are related to all radios in a system.  There are
> > two: KEY_RADIO and SW_RADIO.
> > 
> 
> KEY_RADIO is reserved for selecting radio input (as pooosed to TV, AUX,
> etc) with a remote control. Rfkill woudl need a separate keycode if it
> needs "all types of radios" event.

Hmm, let me check where I got the wrong idea of using KEY_RADIO from,
because thinkpad-acpi already uses KEY_WLAN which means that at least in
the past I did know KEY_RADIO was not to be used for wireless data
communication devices like that...  jeez, looks like spontaneous brain
corruption on that topic hapenned to me sometime ago, and it came out in
a linux-thinkpad thread a few weeks ago.  The wrong semanthics for
KEY_RADIO seem to have stuck to my mind since then.  Drat, I *really*
apologise for this one.

This, of course, is a major NAK for this patch.  And I am considering
dropping the handling of KEY_<whatever replaces RADIO> completely from
it.  SW_RADIO (after a rename, see below) still needs to be handled,
though.

> Btw, is there any devices in the wild that actually have separate
> switches for different types of transmitters?

Separate switches?  I know of none.

Separate hot keys/buttons?  I haven't seen it, but check commit
90da11514562020ea7d697982f912ac949adc317's comment.  That was the commit
which added KEY_WLAN and KEY_BLUETOOTH, back in 2.6.18-rc.  Maybe ask
Lennart Poettering about it?

What I have seen in laptops is:

"Wireless Switch" (SW_RADIO -- this one has a bad name, might even be
what caused me to screw up with the KEY_RADIO thing, and it hints that
my brain corruption was deep rooted, since I was the one who came up
with SW_RADIO).   These switches do their plain best to remove all RF
output when in the "wireles off" position, and stop bothering RF output
when in the "wireless on" position.  Transitions from off->on are often
used as a hint to bring up wireless data communication services (such as
firing up wirelesss settings GUI pannels, etc).

"Wireless hot-key", which either brings up an GUI related to which
wireless data communication radios are active and their configuration,
or directly changes the set of active wireless data communication
radios.

One could easily argue that, should we make it possible for userspace to
interact with the global rfkill state for each rfkill switch type, all
handling of the "Wireless hot-key" should be done in userspace.  I will
go with that for now, and think about it some more.

New patches coming soon.  Please don't merge ANY of the patches in this
set, I will respin the entire series.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

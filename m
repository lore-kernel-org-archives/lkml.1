Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYDMSQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYDMSQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYDMSQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:16:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36335 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbYDMSQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:16:25 -0400
X-Sasl-enc: zwhFSQlc3kuXiy5GemL/uNhbZtX58uR++6u9rSkrt8Ea 1208110584
Date: Sun, 13 Apr 2008 15:16:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6/8] rfkill: add the WWAN radio type
Message-ID: <20080413181621.GC31364@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121623.17453.inaky@linux.intel.com> <20080413172554.GA31364@khazad-dum.debian.net> <200804131937.13385.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804131937.13385.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008, Ivo van Doorn wrote:
> On Sunday 13 April 2008, Henrique de Moraes Holschuh wrote:
> > On Sat, 12 Apr 2008, Inaky Perez-Gonzalez wrote:
> > > Most rfkill hw keys are attached to the device. So I can plug wifi, wimax,
> > > 3G, UWB and BT dongles (or cards) into a system and they each provide a HW
> > > switch (or should provide).
> > > 
> > > If each overrides another one, we have a problem.
> > 
> > Yeah, and we have to avoid such problems.
> > 
> > But let me ask you one thing.  Are we talking of different rfkill
> > switches, OR are we talking about different KEYs or BUTTONS in the
> > keyboard/keypad/console/remote control?
> > 
> > Because one thing has very little to do with the other.  No network
> > device driver shall generate an input event after I am done with the
> > next patch set...
> 
> Not sure if that will be the desired course of action.
> The original rfkill function didn't work with input devices either and just
> handled everything in rfkill.
> But the input layer people requested the change to use input devices and let
> rfkill hook into that, because a rfkill switch/key can be considered an input device.
> 
> I've CC'ed Dmitry into this discussion since he was the one who suggested the
> input device interaction initialy (and created the rfkill-input module).

In order to avoid a lot of misunderstandings, we better name the
"enable/disable radio apparatus" (the circuit/config register that
causes a radio to disable its RF path) and the "input hardware rf-switch
device" (the thing the user presses/moves) in different ways, at least
when we are talking about them.

Right now both are usually called rfkill switch, and much of the mess
comes from that...

"input hardware rf-switch devices" ARE input devices, belong to the
input layer, and issue input events.

"enable/disable radio apparatus" don't, and the input layer should not
be abused as a "status reporting" feature for those.  We certainly will
benefit from those issuing kernel notifications through a notification
chain for them, though.

And many devices are both at the same time (e.g. a b43 in certain
hardware configurations), and many drivers have both types (e.g.
thinkpad-acpi's hotkey subsystem has "input hardare rf-switch devices"
functions, and thinkpad-acpi's bluetooth firmware handling have
"enable/disable radio apparatus" functions).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYDLXYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYDLXYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 19:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYDLXYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 19:24:00 -0400
Received: from mga07.intel.com ([143.182.124.22]:11044 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753558AbYDLXYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 19:24:00 -0400
X-ExtLoop1: 1
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 6/8] rfkill: add the WWAN radio type
Date: Sat, 12 Apr 2008 16:23:17 -0700
User-Agent: KMail/1.9.9
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.45670.IvDoorn@gmail.com> <20080412121554.GB3402@khazad-dum.debian.net>
In-Reply-To: <20080412121554.GB3402@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804121623.17453.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008, Henrique de Moraes Holschuh wrote:
> On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > On Friday 11 April 2008, Henrique de Moraes Holschuh wrote:
> > > Unfortunately, instead of adding a generic Wireless WAN type, a technology-
> > > specific type (WiMAX) was added.  That's useless for other WWAN devices,
> > > such as EDGE, UMTS, X-RTT and other such radios.
> > 
> > Then perhaps we should replace WiMAX with the WWAN type?
> 
> And have KEY_WIMAX interact with WWAN, or rename KEY_WIMAX to KEY_WWAN as
> well?
> 
> I do think it should be OK to do both renames, since it is very unlikely
> that a device would have keys for WIMAX and WWAN at the same type.  We
> don't even have to rename KEY_WIMAX, we can have KEY_WWAN and KEY_WIMAX map
> both to the same keycode.
> 
> Inaky?

I disagree

Most rfkill hw keys are attached to the device. So I can plug wifi, wimax,
3G, UWB and BT dongles (or cards) into a system and they each provide a HW
switch (or should provide).

If each overrides another one, we have a problem.

Is it that unlikely that a device will have 3G and WiMAX support? Not 
really. My laptop might have WWAN built in and then when I travel to some
place where I need WiMAX, I plug a WiMAX USB dongle. Problem. This is just
an example that can be extended to any wireless technology combination.

My point is we should keep it kind of separated, where the guy requesting
the rfkill stuff says "I need a keycode to generate when my hw switch is
operated". And for the rfkill layer to just care about associating that
keycode to that card.

I guess before I didn't have it as clear as I do now, but I am just seeing
more and more that each radio has its own kill switch and then the system
might have a generic one (for example fn+F5 on thinkpads) for killing all
of them at the same time.



-- 
Inaky

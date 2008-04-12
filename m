Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbYDLMQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbYDLMQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbYDLMQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:16:06 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46748 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799AbYDLMQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:16:03 -0400
X-Sasl-enc: iOJFENHUqTK/lci0JnYqEM5aY9Cd8zXHbmtKi5ZDtdpP 1208002562
Date: Sat, 12 Apr 2008 09:15:54 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       =?iso-8859-1?Q?I=F1aky_P=E9rez-Gonz=E1lez?= 
	<inaky.perez-gonzalez@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6/8] rfkill: add the WWAN radio type
Message-ID: <20080412121554.GB3402@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-7-git-send-email-hmh@hmh.eng.br> <200804121236.45670.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804121236.45670.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> On Friday 11 April 2008, Henrique de Moraes Holschuh wrote:
> > Unfortunately, instead of adding a generic Wireless WAN type, a technology-
> > specific type (WiMAX) was added.  That's useless for other WWAN devices,
> > such as EDGE, UMTS, X-RTT and other such radios.
> 
> Then perhaps we should replace WiMAX with the WWAN type?

And have KEY_WIMAX interact with WWAN, or rename KEY_WIMAX to KEY_WWAN as
well?

I do think it should be OK to do both renames, since it is very unlikely
that a device would have keys for WIMAX and WWAN at the same type.  We
don't even have to rename KEY_WIMAX, we can have KEY_WWAN and KEY_WIMAX map
both to the same keycode.

Inaky?

> > Add a WWAN rfkill type for generic wireless WAN devices.  No keys are added
> > as most devices use KEY_RADIO for WWAN control and need no specific keycode
> > added.
> 
> In the discussion around the WiMAX addition I do remember people wanted
> it to have a seperate key code because it was "different technology". Wouldn't that
> be the same for all WWAN technologies?

IMO, this is an USER INTERFACE part of the kernel.  The user will either
interact with radios one-by-one (and the rfkill class provides this anyway,
even without separate types), or he will want to deal with abstract
concepts: "all radios", "wireless wan", "wireles lan", "personal-space
radios (UWB, BT)"...

I.e. I am not even sure we should have UWB and BT as separate types...  but
naming UWB "Bluetooth" would be wrong, too, so a proper fix there is harder
(breaks stable ABI with userspace).

> Aka, should the WiMAX keycode be changed to a WWAN keycode in input.h
> and then be used for all WWAN rfkill switches?

I'd think so.

We can add a desc field to rfkill with a more human-friendly, not required
to be unique, description of the switch.

 e.g.:  "Intel WiMAX 1234 radio switch"
        "ThinkPad builtin bluetooth switch"

and so on.  It will be far more useful than making the switch type a
technology-granular thing.  And it will be useful for GUIs in userspace.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

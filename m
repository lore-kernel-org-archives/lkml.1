Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYDLNI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYDLNI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 09:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbYDLNIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 09:08:49 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39107 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbYDLNIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 09:08:48 -0400
X-Sasl-enc: 7lVHVINislJNte8TIJ/mm7GIL4ytpt9u5xsvdZ8OBYMA 1208005727
Date: Sat, 12 Apr 2008 10:08:45 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 3/8] rfkill: handle KEY_RADIO and SW_RADIO events
Message-ID: <20080412130845.GD3402@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.41635.IvDoorn@gmail.com> <20080412120531.GA3402@khazad-dum.debian.net> <200804121423.59988.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804121423.59988.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> On Saturday 12 April 2008, Henrique de Moraes Holschuh wrote:
> > On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > > On Friday 11 April 2008, Henrique de Moraes Holschuh wrote:
> > > > The *_RADIO input events are related to all radios in a system.  There are
> > > > two: KEY_RADIO and SW_RADIO.
> > > > 
> > > > Teach rfkill-input how to handle them.  In particular, SW_RADIO is not a
> > > > toggle, but an absolute enable-or-disable command.
> > > 
> > > Not sure what you are trying to achieve here,
> > > who triggers the SW_RADIO and why?
> > 
> > Thinkpad-acpi issues EV_SW SW_RADIO when the user changes a phisical
> > switch in the unit.  It is a switch, not a button: it has an ON
> > position, and an OFF position.
> 
> Ok, and such a switch is always intended to control all radios?
> (in other words, it is the expected behavior it controls everything)

In every device I have seen which had a non-type-specific radio switch?
Yes.

If we need type-specific switches (and NOT buttons/hot keys) for, e.g.,
Bluetooth, the correct thing to do is to add EV_SW SW_BLUETOOTH.  The
same goes for WWAN, UWB, etc.  But on laptops (which are the devices I
am dealing with), these switches (when they exist) are meant to block
*every* builtin radio and thus are not type-specific.

I can easily see someone designing a gadget with type-specific switches,
but since nobody asked for such support yet, we don't have anything but
SW_RADIO defined in the input layer right now.

So EV_SW SW_RADIO has "every radio" semanthics, just like KEY_RADIO.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

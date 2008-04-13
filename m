Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYDMRkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYDMRkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYDMRkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:40:13 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53786 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591AbYDMRkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:40:12 -0400
X-Sasl-enc: tN65eKijyA/SZZVdllaVopFo7wq6/WX7KKTXuZhrYEvd 1208108410
Date: Sun, 13 Apr 2008 14:40:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 7/8] rfkill: add an "any radio" switch type and
	functionality
Message-ID: <20080413174005.GB31364@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-8-git-send-email-hmh@hmh.eng.br> <20080412195716.GA4639@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080412195716.GA4639@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Pavel Machek wrote:
> On Fri 2008-04-11 17:37:23, Henrique de Moraes Holschuh wrote:
> > Add a RFKILL_TYPE_ANY switch.  This switch can control more than one type
> > of radio, and it is always subject to toggling by any type of rfkill-input
> > event.  It is suitable to implement kill-all-radios functionality when
> > coupled with input event EV_SW SW_RADIO.
> 
> Hmm, how does that work with pcmcia ethernet card plugged in?

I assume you mean PCMCIA WLAN card.

1. The hardware switch can't kill the WLAN card directly (so, unless
software does something, the radio in the PCMCIA card ignores the
switch).

2. But the hardware switch it is a master switch, so it will issue an
input event, which, IF THE USER WANTS IT TO WORK will be either acted
upon by rfkill-input or userspace.

3. rfkill-input or userspace will tell rfkill to switch all WLAN cards
on or off, because of that input event.

4. The WLAN driver bound to the pcmcia WLAN device gets that command and
changes the radio state.

So, from the user PoV, the PCMCIA WLAN card ends up responding to the
hardware switch, which is better behaviour even than what Windows could
do :p

> How does userspace know which radios this controls?

It doesn't.  Not even the hardware knows :) let alone the drivers...

Which is why we shall try to make all master switches of a given type
control all radios of the same type, so you can at least have some idea
of what happens... and then the answer becomes "all radios of the same
type/class", except for those whose drivers didn't implement an rfkill
interface.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

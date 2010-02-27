Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966776Ab0B0AzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 19:55:10 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53017 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966750Ab0B0AzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 19:55:08 -0500
X-Sasl-enc: SQmVJr3AsnSByXfZ9HEdhBaS2CCpxB8o5hUSUPf6gkZ1 1267232104
Date: Fri, 26 Feb 2010 21:55:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: fix return value of
 volume callbacks
Message-ID: <20100227005501.GA25762@khazad-dum.debian.net>
References: <4B825228.8050405@ladisch.de>
 <20100223031220.GI30470@khazad-dum.debian.net>
 <4B83858C.8010305@ladisch.de>
 <20100226003056.GF5218@khazad-dum.debian.net>
 <4B877A81.4030300@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B877A81.4030300@ladisch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, Clemens Ladisch wrote:
> > > ALSA sends notifications to all mixer application when the value of
> > > any mixer control has changed.  To be able to avoid sending them for
> > > controls that did not actually change, it uses the return value of the
> > > .put callback: 0 means the control value did not change; 1 means it has
> > > changed (or might have changed), and a notification is to be sent.
> > > <http://www.alsa-project.org/~tiwai/writing-an-alsa-driver/ch06s05.html#control-interface-callbacks-put>
> > 
> > I am looking at it.  I think I had it like that on purpose, to trigger an
> > OSD when a volume-related hotkey is pressed even if it doesn't change the
> > state (mute when already mute, vol down when already at minimum, etc).
> 
> This is not about changes initiated by key presses but changes made
> through the ALSA mixer API.  Or does the hardware generate a hotkey
> event when software changes the volume?

The firmware doesn't send events for software changes, mostly because it
does not want, or, expect any.  These mixers are read-only by default.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

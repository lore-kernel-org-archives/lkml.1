Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935489Ab0BZHux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:50:53 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:32832 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935446Ab0BZHuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:50:52 -0500
X-Greylist: delayed 727 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 02:50:52 EST
X-Sasl-enc: /mBT3yfGzT0WgdJ6UyBq6C9bPr/hoe3bgm91lUqiftSx 1267169925
Message-ID: <4B877A81.4030300@ladisch.de>
Date: Fri, 26 Feb 2010 08:38:41 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: fix return value of volume callbacks
References: <4B825228.8050405@ladisch.de> <20100223031220.GI30470@khazad-dum.debian.net> <4B83858C.8010305@ladisch.de> <20100226003056.GF5218@khazad-dum.debian.net>
In-Reply-To: <20100226003056.GF5218@khazad-dum.debian.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Tue, 23 Feb 2010, Clemens Ladisch wrote:
> > Henrique de Moraes Holschuh wrote:
> > > On Mon, 22 Feb 2010, Clemens Ladisch wrote:
> > > > Fix up the volume status setting functions to return a non-zero value if
> > > > the control value has changed, so that the ALSA framework can correctly
> > > > generate control change notifications.
> > > 
> > > Please explain...
> > 
> > ALSA sends notifications to all mixer application when the value of
> > any mixer control has changed.  To be able to avoid sending them for
> > controls that did not actually change, it uses the return value of the
> > .put callback: 0 means the control value did not change; 1 means it has
> > changed (or might have changed), and a notification is to be sent.
> > <http://www.alsa-project.org/~tiwai/writing-an-alsa-driver/ch06s05.html#control-interface-callbacks-put>
> 
> I am looking at it.  I think I had it like that on purpose, to trigger an
> OSD when a volume-related hotkey is pressed even if it doesn't change the
> state (mute when already mute, vol down when already at minimum, etc).

This is not about changes initiated by key presses but changes made
through the ALSA mixer API.  Or does the hardware generate a hotkey
event when software changes the volume?


Regards,
Clemens

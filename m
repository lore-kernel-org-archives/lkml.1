Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934765Ab0BZAbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:31:04 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58270 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934720Ab0BZAbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:31:01 -0500
X-Sasl-enc: Wfw3n3PKM1lpQdYy+Qdu9P/jvUkk0BBfhSjmmjqhCuB3 1267144260
Date: Thu, 25 Feb 2010 21:30:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: fix return value of volume callbacks
Message-ID: <20100226003056.GF5218@khazad-dum.debian.net>
References: <4B825228.8050405@ladisch.de>
 <20100223031220.GI30470@khazad-dum.debian.net>
 <4B83858C.8010305@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B83858C.8010305@ladisch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Clemens Ladisch wrote:
> Henrique de Moraes Holschuh wrote:
> > On Mon, 22 Feb 2010, Clemens Ladisch wrote:
> > > Fix up the volume status setting functions to return a non-zero value if
> > > the control value has changed, so that the ALSA framework can correctly
> > > generate control change notifications.
> > 
> > Please explain...
> 
> ALSA sends notifications to all mixer application when the value of
> any mixer control has changed.  To be able to avoid sending them for
> controls that did not actually change, it uses the return value of the
> .put callback: 0 means the control value did not change; 1 means it has
> changed (or might have changed), and a notification is to be sent.
> <http://www.alsa-project.org/~tiwai/writing-an-alsa-driver/ch06s05.html#control-interface-callbacks-put>

I am looking at it.  I think I had it like that on purpose, to trigger an
OSD when a volume-related hotkey is pressed even if it doesn't change the
state (mute when already mute, vol down when already at minimum, etc).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

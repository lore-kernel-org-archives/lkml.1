Return-Path: <linux-kernel-owner+w=401wt.eu-S1759651AbXH0RLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbXH0RLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbXH0RLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:11:15 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45644 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949AbXH0RLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:11:14 -0400
X-Sasl-enc: KeQa+UnyV05HA08RrKkjBAsp5Ctt6855wBh1iaQc/5cW 1188234672
Date: Mon, 27 Aug 2007 14:11:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Yan Burman <burman.yan@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       hdaps-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.23-rc2]  hwmon: HP Mobile Data Protection System 3D
	ACPI driver (resend)
Message-ID: <20070827171107.GA15647@khazad-dum.debian.net>
References: <1186831562.6452.10.camel@localhost> <20070825102512.GA5850@ucw.cz> <46D01420.3070400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D01420.3070400@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2007, Yan Burman wrote:
>> Aha, /sys. Could we simply power off the device when its input device
>> is not opened?
>>   
> No, we can't since the sys interface provides the position info and some 
> applications (hdaps apps for example) use this interface.

Power it off when not used for some time.  Power on when opened.  -EBUSY
while powering on and before it stablizes, if you don't want to get anything
userland stuck in D state.  This much work might not make sense if your
accelerometer doesn't waste resources when enabled.

Heck, try to get rid of that position sysfs crap if you can! It was a bad
design idea for hdaps to come up with, there is no reason to let it leak to
other drivers.

Input devices are the way to go for this, a joystick-emulation input device
(for games and toys), plus a input device that outputs accelerometer data in
micro (or mili?) gravities (generic stuff that works with all accelerometers
should use this one) and a raw accelerometer data input device (for higly
specific signal processing apps) when possible.

HDAPS (the one that matters, which ships in tp_smapi) lacks the g-normalized
device, though, but it would be a proper generic accelerometer interface.
The in-tree hdaps driver is basically ignored.  So some other accelerometer
driver gets the dibs on how to implement those interfaces in a proper
generic way.  Want to be the one? Please?  We in hdaps-devel can certainly
help with ideas and fix out-of-tree hdaps to also implement the interface.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

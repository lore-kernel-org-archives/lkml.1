Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbXH3Qlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbXH3Qlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759418AbXH3Qlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:41:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58520 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759043AbXH3Qli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:41:38 -0400
X-Sasl-enc: qiaSy+lOvKsBt28jX3d7Ht1NyRFEvnbn6x7Z5bI2nZQY 1188492097
Date: Thu, 30 Aug 2007 13:41:32 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Yan Burman <burman.yan@gmail.com>
Cc: Shem Multinymous <multinymous@gmail.com>,
       hdaps-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [Hdaps-devel] [PATCH 2.6.23-rc2] hwmon: HP Mobile Data
	Protection System 3D ACPI driver (resend)
Message-ID: <20070830164132.GA21023@khazad-dum.debian.net>
References: <1186831562.6452.10.camel@localhost> <20070825102512.GA5850@ucw.cz> <46D01420.3070400@gmail.com> <20070827171107.GA15647@khazad-dum.debian.net> <46D5A742.8090201@gmail.com> <20070829233024.GA7433@khazad-dum.debian.net> <41840b750708291731w3fb5e673k3c1283e4a2fa82f0@mail.gmail.com> <46D6E5CD.4060807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D6E5CD.4060807@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Yan Burman wrote:
>>> You can generate events on input devices, but I am not sure that's the
>>> best way to go about it for this.  Things that block on read until an
>>> interrupt happens might work better.
>>
>> You can do the latter via another (4th) input device.
>>
> What's wrong with the stuff I did in mdps? a misc character device that
> acts like /dev/rtc. Why does it have to be input device oriented?

I am fine with a char device that acts like /dev/rtc, but if we are doing
something as heavyweight as a char device, I'd rather we go full generic
netlink and send the various events over it.  We'd have a netlink device
that sends everything over various "channels" and just one input device that
does joystick emulation, then.

Can we use a simple sysfs attribute that blocks the caller on write and
returns immediately on read? If it has to be more complicated than that, I'd
rather we go the netlink path. Any other ideas that are not a char device,
not a netlink socket, not an input device node, and not a sysfs attribute?

> I also looked at what you did in the patches as well as the modified 
> hdapsd. I'm doing the raw input device right now in the mdps, but I have a 
> suggestion.
>
> It seems to me that right now there are at least 3 drivers that provide the 
> same functionality - hdaps, ams and mdps. Why not create the input device
> that exports raw accelerometer data with a name that is generic - something 
> like accel/input or something along those lines. This way hdapsd could work
> with any driver that provides the functionality without being hdaps 
> specific.

THAT is the idea, IMO.  But the naming is userspace's problem (thorugh
udev), not ours :-)

Or do you mean the "hardware port" part of the input device? If so, yes, we
should try to make standard names for those as that makes it easier for
userspace.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbYFZX66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbYFZX66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 19:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYFZX6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 19:58:47 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:40019 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbYFZX6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 19:58:46 -0400
Subject: Re: [v4l-dvb-maintainer] saa7134 duplicate device in module, but
	different device_data?
From: hermann pitton <hermann-pitton@arcor.de>
To: Ben Collins <ben.collins@canonical.com>,
       Hartmut Hackmann <hartmut.hackmann@t-online.de>
Cc: v4l-dvb-maintainer@linuxtv.org, kernel list <linux-kernel@vger.kernel.org>,
       video4linux-list@redhat.com
In-Reply-To: <1214501094.7150.29.camel@cunning>
References: <1214501094.7150.29.camel@cunning>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 01:56:20 +0200
Message-Id: <1214524580.4480.32.camel@pc10.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am Donnerstag, den 26.06.2008, 13:24 -0400 schrieb Ben Collins:
> In the saa7134 module, there are these two entries in
> MODULE_DEVICE_TABLE():
> 
> 
>         },{
>                 .vendor       = PCI_VENDOR_ID_PHILIPS,
>                 .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
>                 .subvendor    = 0x185b,
>                 .subdevice    = 0xc100,
>                 .driver_data  = SAA7134_BOARD_VIDEOMATE_TV,
>         },{
>                 .vendor       = PCI_VENDOR_ID_PHILIPS,
>                 .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
>                 .subvendor    = 0x185b,
>                 .subdevice    = 0xc100,
>                 .driver_data  = SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUS,
>         },{
> 
> Both will exactly match, and I assume only the first one will ever be
> used, hence the second is just a wasted dupe. At least, I would assume
> if not for the differing driver_data. Anyway to clear up this ambiguity?
> 

there are even more devices with the same PCI device and subsystem ID
from that vendor and the problem goes also over saa7133 and saa7135
devices, for which we have no means to detect them as different, but the
saa7133 does only NTSC-M system TV sound decoding and saa7135 and the
even later saa7131e global analog TV sound.

For the early saa7133 SAA7134_BOARD_VIDEOMATE_TV we don't have eeprom
readout data and the contributor doesn't have the card anymore.
A request for helping out with such on the list had no result so far.

As of now, we can't try to separate them by eeprom differences, which
would be the best attempt and is done for some other Compro products
with similar flaws already.

Before that likely possible eeprom detection ever happens, we have two
options left to make you feel better.

Kick both out of the auto detection and the users will get a list of
supported devices printed out, from which they have to choose.

Leave the oldest one in and print some warnings that they have to look
it up for their newer cards. Naming is quite consistent, except some
early Gold Plus II variants seen first in New Zealand coming with Gold
Plus only stickers. They also come with different tuners, latest have a
separate silicon radio tuner and all such usual ...

Patches are always welcome.

Internally it was only a reminder for missing eeprom data to be
investigated.

Cheers,
Hermann





Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYF0AHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYF0AHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 20:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYF0AGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 20:06:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33990 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYF0AGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 20:06:52 -0400
Subject: Re: [v4l-dvb-maintainer] saa7134 duplicate device in module, but
	different device_data?
From: Ben Collins <ben.collins@canonical.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
       v4l-dvb-maintainer@linuxtv.org,
       kernel list <linux-kernel@vger.kernel.org>, video4linux-list@redhat.com
In-Reply-To: <1214524580.4480.32.camel@pc10.localdom.local>
References: <1214501094.7150.29.camel@cunning>
	 <1214524580.4480.32.camel@pc10.localdom.local>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 26 Jun 2008 20:06:46 -0400
Message-Id: <1214525206.7150.118.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 01:56 +0200, hermann pitton wrote:
> Hello,
> 
> Am Donnerstag, den 26.06.2008, 13:24 -0400 schrieb Ben Collins:
> > In the saa7134 module, there are these two entries in
> > MODULE_DEVICE_TABLE():
> > 
> > 
> >         },{
> >                 .vendor       = PCI_VENDOR_ID_PHILIPS,
> >                 .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
> >                 .subvendor    = 0x185b,
> >                 .subdevice    = 0xc100,
> >                 .driver_data  = SAA7134_BOARD_VIDEOMATE_TV,
> >         },{
> >                 .vendor       = PCI_VENDOR_ID_PHILIPS,
> >                 .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
> >                 .subvendor    = 0x185b,
> >                 .subdevice    = 0xc100,
> >                 .driver_data  = SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUS,
> >         },{
> > 
> > Both will exactly match, and I assume only the first one will ever be
> > used, hence the second is just a wasted dupe. At least, I would assume
> > if not for the differing driver_data. Anyway to clear up this ambiguity?
> > 
> 
> there are even more devices with the same PCI device and subsystem ID
> from that vendor and the problem goes also over saa7133 and saa7135
> devices, for which we have no means to detect them as different, but the
> saa7133 does only NTSC-M system TV sound decoding and saa7135 and the
> even later saa7131e global analog TV sound.
> 
> For the early saa7133 SAA7134_BOARD_VIDEOMATE_TV we don't have eeprom
> readout data and the contributor doesn't have the card anymore.
> A request for helping out with such on the list had no result so far.
> 
> As of now, we can't try to separate them by eeprom differences, which
> would be the best attempt and is done for some other Compro products
> with similar flaws already.
> 
> Before that likely possible eeprom detection ever happens, we have two
> options left to make you feel better.
> 
> Kick both out of the auto detection and the users will get a list of
> supported devices printed out, from which they have to choose.
> 
> Leave the oldest one in and print some warnings that they have to look
> it up for their newer cards. Naming is quite consistent, except some
> early Gold Plus II variants seen first in New Zealand coming with Gold
> Plus only stickers. They also come with different tuners, latest have a
> separate silicon radio tuner and all such usual ...
> 
> Patches are always welcome.
> 
> Internally it was only a reminder for missing eeprom data to be
> investigated.

Well I was thinking that mainly, this was just a table for loading and
binding the driver with a device. In that case, only one entry is
needed. The probing would have to decide which device it is.

I'm not up for suggesting a fix, because I don't know enough about the
background. This email is just a friendly reminder that there exists
ambiguity, and at least for one of these devices, the driver isn't going
to detect it properly anyway :)


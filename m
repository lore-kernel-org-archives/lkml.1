Return-Path: <linux-kernel-owner+w=401wt.eu-S1762076AbXFJUqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076AbXFJUqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbXFJUqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:46:25 -0400
Received: from rtr.ca ([64.26.128.89]:3551 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbXFJUqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:46:24 -0400
Message-ID: <466C631D.2000001@rtr.ca>
Date: Sun, 10 Jun 2007 16:46:21 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Robert de Rooy <robert.de.rooy@gmail.com>
Cc: Mark Lord <mlord@pobox.com>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com>	<464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com>	<46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com>	<46518798.2020808@gmail.com> <4651B66E.6030505@gmail.com>	<4651B834.3060702@gmail.com> <4651C4A1.6000101@gmail.com>	<4651C74B.7020108@gmail.com> <46520B36.90409@garzik.org> <20070523150229.00a0c3c4@the-village.bc.nu> <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com> <4669D3F5.7040300@rtr.ca> <466B4D86.1020808@gmail.com>
In-Reply-To: <466B4D86.1020808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert de Rooy wrote:
> Mark Lord wrote:
>> Oh crap.  I did test it a couple of months ago, but my boot/root drive
>> is libata not IDE -- so no panic on boot with it.  After booting, it 
>> worked
>> just fine talking to PC-CARD CF devices using the polling.
> 
> Ok, no problem. I recompiled the kernel with libata (but without the 
> libata pcmcia support), and made legacy ide (only ide-core and ide-cs) 
> modular.
> This allowed me to boot my PATA HDD with libata, and when I plugged in 
> the PCMCIA card it picked it up automatically with the legacy ide drivers.

Good stuff!

> Jun 10 02:40:06 localhost kernel: pccard: PCMCIA card inserted into slot 0
> Jun 10 02:40:07 localhost kernel: cs: memory probe 
> 0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
> Jun 10 02:40:07 localhost kernel: cs: memory probe 
> 0xc0200000-0xcfffffff: excluding 0xc0200000-0xc11fffff 
> 0xc1a00000-0xc21fffff 0xc2a00000-0xc31fffff 0xc3a00000-0xcc1fffff 
> 0xcca00000-0xcd1fffff 0xcda00000-0xce1fffff 0xcea00000-0xcf1fffff 
> 0xcfa00000-0xd01fffff
> Jun 10 02:40:07 localhost kernel: pcmcia: registering new device pcmcia0.0
> Jun 10 02:40:07 localhost kernel: Uniform Multi-Platform E-IDE driver 
> Revision: 7.00alpha2
> Jun 10 02:40:07 localhost kernel: ide: Assuming 33MHz system bus speed 
> for PIO modes; override with idebus=xx
> Jun 10 02:40:07 localhost kernel: hda: Memory Card Adapter, CFA DISK drive
> Jun 10 02:40:08 localhost kernel: ide0 at 0x4100-0x4107,0x410e on irq 3
> Jun 10 02:40:08 localhost kernel: ide-cs: hda: Vpp = 0.0
> Jun 10 02:40:08 localhost udevd-event[2630]: udev_rules_apply_format: 
> unknown format variable '$modalias'
> 
> At this point I noticed no /dev/hda* devices existed, so I created them 
> manually with mknod. But regardless I was not able to actually mount a 
> filesystem, getting an error from mount that the device did not exist.

Yeah, I don't see any "parition table" messages there,
so it must've hung on the I/O somehow.
Bummer, but it was worth trying, I suppose.

> When pulling the card I also got the following..
> 
..
> Jun 10 02:41:53 localhost kernel: [ INFO: soft-safe -> soft-unsafe lock 
> order detected ]
..
That's probably some weird interaction with the simple polling patch,
so I think we can disregard it, unless it pops up again someday on
an unpatched kernel.

Well, at this point, I think the only way to make progress is for one of
the IDE/libata gurus to actually get hold of the same card you have,
meaning Alan Cox (best choice), or myself, or Bart.  Or maybe Tejun.

Without that, this isn't likely to improve much.  

Cheers

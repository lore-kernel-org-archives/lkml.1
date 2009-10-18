Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZJRJkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZJRJkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 05:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZJRJkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 05:40:52 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:31950 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZJRJku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 05:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=japyqyF3KAaSK8lefo4DwA1zQxwyugI3jjuN7uewn8JkqLryZIS5ZIp4GGS58pd4OG
         mJAqSp+L4hUVFonsv5DObsVD1pC0nNQ9aLr92boCevq/+IZdwHUdRM52qQ/j4Jo74NM9
         t8GS3INyH4YYgep8F/+sJ89MmT0xcqnvJHmFI=
MIME-Version: 1.0
In-Reply-To: <200910172318.56929.bzolnier@gmail.com>
References: <200910152137.58164.IvDoorn@gmail.com>
	 <200910152204.16407.IvDoorn@gmail.com>
	 <200910171654.03344.bzolnier@gmail.com>
	 <200910172318.56929.bzolnier@gmail.com>
Date: Sun, 18 Oct 2009 10:40:53 +0100
Message-ID: <efe7343f0910180240o223ac346j3dd7c45c7460ec41@mail.gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
From: Luis Correia <luis.f.correia@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, John Linville <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, users@host1.serialmonkey.com,
       Alban Browaeys <prahal@yahoo.com>,
       Benoit PAPILLAULT <benoit.papillault@free.fr>,
       Felix Fietkau <nbd@openwrt.org>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       Mark Asselstine <asselsm@gmail.com>,
       Xose Vazquez Perez <xose.vazquez@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 22:18, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Saturday 17 October 2009 16:54:03 Bartlomiej Zolnierkiewicz wrote:
>>
>> [ I somehow missed this one by not being on cc: ]
>>
>> On Thursday 15 October 2009 22:04:14 Ivo van Doorn wrote:
>> > Add support for the rt2860/rt3090 chipsets from Ralink.
>> >
>> > Includes various patches from a lot of people who helped
>> > getting this driver into the current shape.
>> >
>> > Signed-off-by: Alban Browaeys <prahal@yahoo.com>
>> > Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
>> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> > Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
>> > Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
>> > Signed-off-by: Mark Asselstine <asselsm@gmail.com>
>> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>> > ---
>> > http://kernel.org/pub/linux/kernel/people/ivd/patches/0003-rt2x00-Implement-support-for-rt2800pci.patch
>>
>> First let me say that I'm very happy to see this patch finally being
>> submitted and I appreciate the effort..
>>
>> (I'll give it a spin on Eee 901 w/ 2.6.32-rc5 sometime later..)
>
> Unfortunately still no luck with it, works just like it worked when I first
> tried it half a year ago (loads OK but "iwlist wlan0 scan" doesn't bring any
> results)..
>
> Could somebody with the genuine RT2860 revision of the chip try the driver
> and confirm that it works w/ 2.6.32-rc5 so I will know whether I should be
> looking for some generic problem or RT2880 revision specific one?

With my RaLink RT2760 Wireless 802.11n 1T/2R Cardbus [1814:0701], it
fails right after loading the firmware to the card.
(this is an internal PCI card, not cardbus)

Oct 16 23:08:15 lc kernel: phy0 -> rt2x00_set_chip: Info - Chipset
detected - rt: 0701, rf: 0003, rev: 28600102.
Oct 16 23:08:23 lc kernel: phy0 -> rt2x00lib_request_firmware: Info -
Loading firmware file 'rt2860.bin'.
Oct 16 23:08:23 lc kernel: phy0 -> rt2x00lib_request_firmware: Info -
Firmware detected - version: 0.11.
Oct 16 23:08:23 lc kernel: phy0 -> rt2x00pci_regbusy_read: Error -
Indirect register access failed: offset=0x00007010, value=0xffffffff
Oct 16 23:08:23 lc kernel: phy0 -> rt2x00pci_regbusy_read: Error -
Indirect register access failed: offset=0x00007010, value=0xffffffff
Oct 16 23:08:23 lc kernel: phy0 -> rt2x00pci_regbusy_read: Error -
Indirect register access failed: offset=0x00007010, value=0xffffffff
Oct 16 23:08:23 lc kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
Oct 16 23:08:23 lc kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
Oct 16 23:08:23 lc kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
Oct 16 23:08:23 lc kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.

We get those "regbusy errors" and then, the MCU no longer accepts any command.

Oddly though, it can scan and detect the surrounding AP's.


Luis Correia,
rt2x0 project admin

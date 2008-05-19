Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbYESTUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbYESTUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYESTUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:20:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:11223 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbYESTU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VWiFV5/eIEVZPr9AJPYI5Ub4xQGkOYEb98FePxu6e1LAK+EbBR80Vk77H0Ed1jx5H99Pf6Atco6omyzuur7UJZC9K2TAMxTz60MY7pf46agr8I70PAKKuxB4wDtm5NDQ2IGbROQW3cReIgDaWf6NpEkRLFoN/7WrG78QfrNm38k=
Message-ID: <15577be70805191220h4413a9c1n11d7240a2906e056@mail.gmail.com>
Date: Mon, 19 May 2008 21:20:26 +0200
From: "Abel Bernabeu" <abel.bernabeu@gmail.com>
To: patrizio.bassi@gmail.com
Subject: Re: 2.6.25: usb-storage unknown partition table issue
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48319C1F.6030005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48319C1F.6030005@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like you did not enable the partition type "PC BIOS".

Type "make menuconfig" and make sure you enabled it on:

Partition types / Advanced partition / pc bios (ms dos partition tables)

Discard any SCSI issue, indeed I am almost sure you can do a "cp
/dev/sda /dev/null" with no problem (showing that your SCSI driver is
working properly).

Yours, Abel.



2008/5/19 Patrizio Bassi <patrizio.bassi@gmail.com>:
> Hi,
>
> i have a 8GB usb pen with several problem due to partition table.
>
> if i create a primary one with fdisk, then format it works ok.
> then i umount it, unplug, replug, no more partition detected.
>
> I formatted it on Windows (same machine) and this some stress test, but it's
> brand new and it works.
> The partition and the free space is correctly seen by qtparted and parted,
> but in the dmesg i see:
>
> Initializing USB Mass Storage driver...
> scsi10 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usb-storage: device scan complete
> scsi 10:0:0:0: Direct-Access     Ut165    USB2FlashStorage 0.00 PQ: 0 ANSI:
> 2
> sd 10:0:0:0: [sdc] 15794176 512-byte hardware sectors (8087 MB)
> sd 10:0:0:0: [sdc] Write Protect is off
> sd 10:0:0:0: [sdc] Mode Sense: 00 00 00 00
> sd 10:0:0:0: [sdc] Assuming drive cache: write through
> sd 10:0:0:0: [sdc] 15794176 512-byte hardware sectors (8087 MB)
> sd 10:0:0:0: [sdc] Write Protect is off
> sd 10:0:0:0: [sdc] Mode Sense: 00 00 00 00
> sd 10:0:0:0: [sdc] Assuming drive cache: write through
> sdc: unknown partition table
> sd 10:0:0:0: [sdc] Attached SCSI removable disk
>
> This makes the partition unasable in my linux 2.6.25 (vanilla) system.
> Another 1gb usbpen works perfectly.
>
> Bus 004 Device 001: ID 1d6b:0001
> Bus 005 Device 001: ID 1d6b:0001
> Bus 002 Device 001: ID 1d6b:0001
> Bus 003 Device 001: ID 1d6b:0001
> Bus 001 Device 002: ID 1307:0165 Transcend Information, Inc.
> Bus 001 Device 001: ID 1d6b:0002
>
> Anything i can try?
> It looks a scsi issue. And it's the first time i see the Mode Sense set to 0
> for any usb storage device.
>
> Please CC me i'm not subscribed
>
> --
> Patrizio Bassi
> www.patriziobassi.it
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

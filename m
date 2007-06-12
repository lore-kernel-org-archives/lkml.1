Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbXFLDYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbXFLDYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbXFLDY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:24:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:51144 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbXFLDY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=O93QWZWPemICuV56DKtPPAo9pOKKSCb/UnVH2ncNUxGJWNhWxVXksP6P7WAXOzu3IZcytQ1Pyj0AdNRE0ewKpYbV9l8zPpjE8SMy9Czc1TbQLoOtrrTuLhFK+zp3g5Zw4U3c12HrJOMaURyZWdvE27LGWWdSPAgB/WnyBZa+foo=
Message-ID: <466E11DF.5020901@gmail.com>
Date: Tue, 12 Jun 2007 12:24:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <mlord@pobox.com>
CC: Robert de Rooy <robert.de.rooy@gmail.com>, Mark Lord <liml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata and legacy ide pcmcia failure
References: <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com> <4669D3F5.7040300@rtr.ca> <466B4D86.1020808@gmail.com> <466C631D.2000001@rtr.ca> <466C723C.6000300@gmail.com> <20070610221322.GA18196@flint.arm.linux.org.uk> <466C7A9F.1080700@rtr.ca> <466DCE55.30507@gmail.com> <466DCF43.5060304@pobox.com>
In-Reply-To: <466DCF43.5060304@pobox.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Robert de Rooy wrote:
>> (after applying the ide-polling experimental patch)
>>
>> With this I can declare success!! I was able to read and write to the
>> card without any problems, although I did not try to stress it.
>>
>> Jun 12 00:19:42 localhost kernel: pccard: PCMCIA card inserted into
>> slot 0
>> Jun 12 00:19:42 localhost kernel: cs: memory probe
>> 0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
>> Jun 12 00:19:42 localhost kernel: cs: memory probe
>> 0xc0200000-0xcfffffff: excluding 0xc0200000-0xc11fffff
>> 0xc1a00000-0xc21fffff 0xc2a00000-0xc31fffff 0xc3a00000-0xcc1fffff
>> 0xcca00000-0xcd1fffff 0xcda00000-0xce1fffff 0xcea00000-0xcf1fffff
>> 0xcfa00000-0xd01fffff
>> Jun 12 00:19:42 localhost kernel: pcmcia: registering new device
>> pcmcia0.0
>> Jun 12 00:19:42 localhost kernel: Uniform Multi-Platform E-IDE driver
>> Revision: 7.00alpha2
>> Jun 12 00:19:42 localhost kernel: ide: Assuming 33MHz system bus speed
>> for PIO modes; override with idebus=xx
>> Jun 12 00:19:45 localhost kernel: hda: Memory Card Adapter, CFA DISK
>> drive
>> Jun 12 00:19:45 localhost kernel: ide0 at 0x4100-0x4107,0x410e on irq 3
>> Jun 12 00:19:45 localhost kernel: ide-cs: hda: Vpp = 0.0
>> Jun 12 00:19:45 localhost udevd-event[20730]: udev_rules_apply_format:
>> unknown format variable '$modalias'
>> Jun 12 00:19:45 localhost kernel: hda: max request size: 128KiB
>> Jun 12 00:19:45 localhost kernel: hda: 253696 sectors (129 MB) w/1KiB
>> Cache, CHS=991/16/16
>> Jun 12 00:19:45 localhost kernel:  hda: hda1
>> Jun 12 00:19:48 localhost hald: mounted /dev/hda1 on behalf of uid 0
> 
> Okay, Tejun / Bart / Alan:
> 
> This proves that the device does work correctly in most respects
> except for interrupt delivery.  The status bits are working and
> it can be probed for, configured, and used.

libata can do most of this too by using ATA_FLAG_PIO_POLLING (doesn't
cover nodata commands tho).

-- 
tejun

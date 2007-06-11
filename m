Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbXFKUgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbXFKUgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbXFKUge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:36:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:21334 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbXFKUgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AAFIM2+zhuFDoNpLlnxx/1CKJBmQuPP9mGcfrp8ybSOyHdGWSU3jkSgPQoAZIjKpvasDQLz9yEctvO11pHsOxDYdcP3GY2WeAwUcp1zleCBowuNdetqGrFo8Ba/dYgvjeLFt87Z8PaNJVxSsT2nnPVKNsGtWqUP53Ts8r7IQlR4=
Message-ID: <466DCE55.30507@gmail.com>
Date: Tue, 12 Jun 2007 00:36:05 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Mark Lord <lkml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mark Lord <mlord@pobox.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata and legacy ide pcmcia failure
References: <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com> <4669D3F5.7040300@rtr.ca> <466B4D86.1020808@gmail.com> <466C631D.2000001@rtr.ca> <466C723C.6000300@gmail.com> <20070610221322.GA18196@flint.arm.linux.org.uk> <466C7A9F.1080700@rtr.ca>
In-Reply-To: <466C7A9F.1080700@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Russell King wrote:
>>
>> Before you do, it might help to build the ide-disk module and insert 
>> that
>> as well?
>
> ARrrggghh!!  Of course, that would explain the utter lack
> of disk partition check messages, now wouldn't it!
>
> Thanks Russell !
>

Doh! yes that would obviously help.
With this I can declare success!! I was able to read and write to the 
card without any problems, although I did not try to stress it.

Jun 12 00:19:42 localhost kernel: pccard: PCMCIA card inserted into slot 0
Jun 12 00:19:42 localhost kernel: cs: memory probe 
0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
Jun 12 00:19:42 localhost kernel: cs: memory probe 
0xc0200000-0xcfffffff: excluding 0xc0200000-0xc11fffff 
0xc1a00000-0xc21fffff 0xc2a00000-0xc31fffff 0xc3a00000-0xcc1fffff 
0xcca00000-0xcd1fffff 0xcda00000-0xce1fffff 0xcea00000-0xcf1fffff 
0xcfa00000-0xd01fffff
Jun 12 00:19:42 localhost kernel: pcmcia: registering new device pcmcia0.0
Jun 12 00:19:42 localhost kernel: Uniform Multi-Platform E-IDE driver 
Revision: 7.00alpha2
Jun 12 00:19:42 localhost kernel: ide: Assuming 33MHz system bus speed 
for PIO modes; override with idebus=xx
Jun 12 00:19:45 localhost kernel: hda: Memory Card Adapter, CFA DISK drive
Jun 12 00:19:45 localhost kernel: ide0 at 0x4100-0x4107,0x410e on irq 3
Jun 12 00:19:45 localhost kernel: ide-cs: hda: Vpp = 0.0
Jun 12 00:19:45 localhost udevd-event[20730]: udev_rules_apply_format: 
unknown format variable '$modalias'
Jun 12 00:19:45 localhost kernel: hda: max request size: 128KiB
Jun 12 00:19:45 localhost kernel: hda: 253696 sectors (129 MB) w/1KiB 
Cache, CHS=991/16/16
Jun 12 00:19:45 localhost kernel:  hda: hda1
Jun 12 00:19:48 localhost hald: mounted /dev/hda1 on behalf of uid 0


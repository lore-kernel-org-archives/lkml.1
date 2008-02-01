Return-Path: <linux-kernel-owner+w=401wt.eu-S1759971AbYBAKE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbYBAKE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYBAKEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:04:52 -0500
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:62534
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755166AbYBAKEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:04:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAF99okd8qNBs/2dsb2JhbACtbw
X-IronPort-AV: E=Sophos;i="4.25,289,1199631600"; 
   d="scan'208";a="220644519"
Message-ID: <47A2EEBD.3050705@eyal.emu.id.au>
Date: Fri, 01 Feb 2008 21:04:45 +1100
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Organization: Eyal at Home
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: list linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.14 snd_hda_intel problem
References: <47A25998.1000501@eyal.emu.id.au> <47A2DEAC.7000004@ladisch.de>
In-Reply-To: <47A2DEAC.7000004@ladisch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens

My /etc/modprobe.conf now contains:
	alias snd-card-0 snd-hda-intel
	options snd-card-0 index=0
	options snd-hda-intel index=0
and and I should add
	options snd-usb-audio index=1
right?

Any idea why has this changed between the two minor kernel revisions though?

Thanks
	Eyal

Clemens Ladisch wrote:
> Eyal Lebedinsky wrote:
>> A recent update to 2.6.23.14-64.fc7 lost sound. The boot log now has
>> 	hda-intel: Error creating card!
>> 	HDA Intel: probe of 0000:00:1b.0 failed with error -12
> 
> The two lines before:
> | usbcore: registered new interface driver snd-usb-audio
> | cannot find the slot for index 0 (range 0-0), error: -16
> 
> ... show that a USB audio device was loaded as the first card (at
> index 0), and that the HDA device doesn't load because it tries to go
> to the same index.
> 
> Use the sound card configuration utility of your distribution to
> configure the USB audio device to be the second device, or add the line
>   options snd-usb-audio index=1
> to /etc/modprobe.conf.
> 
> HTH
> Clemens

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)

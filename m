Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687Ab0AZNIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0AZNIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656Ab0AZNIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:08:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab0AZNIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:08:47 -0500
Date: Tue, 26 Jan 2010 14:08:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Antti Palosaari <crope@iki.fi>
Cc: Jiri Slaby <jirislaby@gmail.com>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
       Pekka Sarnila <sarnila@adit.fi>
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
In-Reply-To: <4B5DDDFB.5020907@iki.fi>
Message-ID: <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz>
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010, Antti Palosaari wrote:

> > What happens if you disable the HID layer? Or at least if you add an
> > ignore quirk for the device in usbhid?
> 
> Looks like Fedora doesn't have usbhid compiled as module. I looked
> hid-quirks.c file and there was only one af9015 device blacklisted 15a4:9016.
> I have 15a4:9015, 15a4:9016 and 13d3:3237 devices and no difference.
> 
> How can I disable HID layer?

In case usbhid is compiled in, you should still be able to force the 
ignore quirk by passing

	usbhid.quirks=0x15a4:0x9015:0x04

to kernel boot commandline.

> > I forbid usbhid to attach to the device, as the remote kills X with HID
> > driver. With dvb-usb-remote it works just fine (with remote=2 for af9015
> > or the 4 patches I've sent).
> 
> In my understanding the cause of the remote problem is chipset bug which sets
> USB2.0 polling interval to 4096ms. Therefore HID remote does not work at all
> or starts repeating. It is possible to implement remote as polling from the
> driver which works very well. But HID problem still remains. I have some hacks
> in my mind to test to kill HID. One is to configure HID wrongly to see if it
> stops outputting characters. Other way is try to read remote codes directly
> from the chip memory.

Yes, Pekka Sarnila has added this workaround to the HID driver, as the 
device is apparently broken.

I want to better understand why others are not hitting this with the 
DVB remote driver before removing the quirk from HID code completely.

> But all in all, your patch does not break anything, it is safe to add. It
> could be still nice to know if there is better alternatives. And there is
> surely few other devices having HID remote - are those also affected.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.


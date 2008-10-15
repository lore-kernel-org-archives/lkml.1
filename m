Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYJOVHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYJOVHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYJOVHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:07:35 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:51876 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbYJOVHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:07:34 -0400
From: =?iso-8859-1?q?C=E9dric_Br=E9gardis?= <cedric.bregardis@free.fr>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: The snd-aw2 audio driver conflicts with saa7146-based video adapters
Date: Wed, 15 Oct 2008 23:07:29 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Chuck Ebbert <cebbert@redhat.com>, jhassler@free.fr,
       linux-kernel@vger.kernel.org
References: <20081013195923.361f3726@redhat.com> <s5htzbfohv0.wl%tiwai@suse.de>
In-Reply-To: <s5htzbfohv0.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810152307.30477.cedric.bregardis@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tuesday 14 October 2008, Takashi Iwai a écrit :
> At Mon, 13 Oct 2008 19:59:23 -0400,
>
> Chuck Ebbert wrote:
> > snd-aw2 ("Emagic Audiowerk 2 sound driver") matches on PCI ID for any
> > board containing an saa7146 chip. When the driver loads it blocks the
> > proper driver from loading. It also blindly assumes that it is driving an
> > aw2 adapter and just starts writing to various I/O ports...
>
> Indeed, that's bad.
> I guess simply adding PCI SSID would solve this (hopefully).
>
> Cedric, Jean, could you show "lspci -nv" output of the AW2 device?
> (more better submit a patch? :)

Here is lspci -nv for aw2:

02:0b.0 0480: 1131:7146 (rev 01)
        Flags: medium devsel, IRQ 19
        Memory at feafbc00 (32-bit, non-prefetchable) [size=512]

And here is lspci -x:

02:0b.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
00: 31 11 46 71 02 00 80 02 01 00 80 04 00 40 00 00
10: 00 bc af fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00

So, the subsystem id and subsystem vendor id is 0, which is the default value 
for SAA7146. SAA7146 can be configured to use a specific subid with an eeprom, 
but it is not done here. However we can verify that the subid is zero. It is 
not a perfect solution, but it is better than nothing. I will try to provide a 
patch next week.

However what can we do if there is another card with SAA7146 and with the 
default subid which is not the aw2 sound card ?

Best regards,
Cedric

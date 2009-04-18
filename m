Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZDRNuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZDRNuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 09:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZDRNuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 09:50:24 -0400
Received: from mail-qy0-f126.google.com ([209.85.221.126]:59788 "EHLO
	mail-qy0-f126.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbZDRNuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 09:50:23 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Apr 2009 09:50:23 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aVbCZSviJCbnudzOhWoHCbC6o99165DGrwYJLAmeFN8Ze1meJ66yMoHloyEaXdQhmj
         4wpgYtQdGnl9yOhSvaF0tzF1L+8g8NyM39Ziw+uQUlt3iNpw+Ra59xUoR6wcyieiBHa5
         4JXkQWLEWxllLvi49m5W0qGkgjd21fkiY+DVs=
MIME-Version: 1.0
In-Reply-To: <200904181222.33869.florian@openwrt.org>
References: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at>
	 <200904171632.26091.florian@openwrt.org>
	 <a3ca03e82d9afad72346dc5b4ae251c7.squirrel@webmail.it-technology.at>
	 <200904181222.33869.florian@openwrt.org>
Date: Sat, 18 Apr 2009 09:42:10 -0400
Message-ID: <9e4733910904180642v5d11451as984271305ab91294@mail.gmail.com>
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
From: Jon Smirl <jonsmirl@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: Peter Holik <peter@holik.at>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 6:22 AM, Florian Fainelli <florian@openwrt.org> wrote:
> Le Saturday 18 April 2009 08:48:22 Peter Holik, vous avez écrit :
>> > Hi Peter,
>> >
>> > Nice to see such a driver coming up!
>>
>> thanks
>>
>> > Le Friday 17 April 2009 16:10:24 Peter Holik, vous avez écrit :
>> >> Signed-off-by: Peter Holik <peter@holik.at>
>> >> ---
>> >>  drivers/net/usb/Kconfig    |    7 +
>> >>  drivers/net/usb/Makefile   |    2 +-
>> >>  drivers/net/usb/intellon.c |  273
>> >> ++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 281
>> >> insertions(+), 1 deletions(-)
>> >>  create mode 100644 drivers/net/usb/intellon.c
>> >>
>> >> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
>> >> index 8ee2103..068faa5 100644
>> >> --- a/drivers/net/usb/Kconfig
>> >> +++ b/drivers/net/usb/Kconfig
>> >> @@ -345,4 +345,11 @@ config USB_HSO
>> >>      To compile this driver as a module, choose M here: the
>> >>      module will be called hso.
>> >>
>> >> +config USB_NET_INTELLON
>> >> +  tristate "Intellon PLC based usb adapter"
>> >> +  depends on USB_USBNET
>> >> +  help
>> >> +    Choose this option if you're using a PLC (Powerline Communications)
>> >> +    solution with an Intellon chip, like the "devolo dLan duo".
>> >> +
>> >
>> > Please be more specific, i.e: using a USB-based PLC (...) solution.
>> >
>> > There might be support for PLC PHYs connected to a MII-bus in a near
>> > future, even though they will not reside in drivers/net/usb/.
>>
>> What do you mean with the last sentence?
>
> I mean that one might come up with a design that uses Intellon PLC PHY chips
> only with a custom MAC chip, not integrated MAC+PHY chips only, therefore a
> more specific naming is required, that's purely cosmetic though.

Those chips that look like PHY chips are just fancy A/D D/A converters.

When connected via Ethernet the chips don't need any drivers. But the
higher speed devices need firmware loaded. Firmware is loaded by
writing normal packets to the device with a specific Intellon owned
Ethernet address. I load the firmware in u-boot so that I can NFS
boot, but you could also load it in Linux. These chips have an
embedded ARM9 core.

More work could be done to integrate Linux commands for changing the
Ethernet address, link encryption key, etc. I just statically set
these in my firmware image. You change them by writing packets to the
special address.

Powerline networking uses technology that is very similar to 802.11g
but with different error recovery encoding. I suspect it is possible
to build a powerline device using 802.11 MAC hardware and different
firmware.

-- 
Jon Smirl
jonsmirl@gmail.com

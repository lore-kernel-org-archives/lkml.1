Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZDRKWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZDRKWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 06:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZDRKWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 06:22:38 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:65383 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZDRKWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 06:22:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=aSx0AikjLdFrpoMs6mNpiNo478jD8QKiXxRV5DNrA8C8hJ0461XKmCI1bGDLK+PugX
         wN6+dImebUBzOyAtBbchfl08yaW1mqO6TjmJ8M5S5nBSCd7rbksEm78O/KkTrR7vLNMS
         Qu00ml5tbD/dAATKqNn17te3xlEfRIWD3HdlQ=
From: Florian Fainelli <florian@openwrt.org>
To: "Peter Holik" <peter@holik.at>
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
Date: Sat, 18 Apr 2009 12:22:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at> <200904171632.26091.florian@openwrt.org> <a3ca03e82d9afad72346dc5b4ae251c7.squirrel@webmail.it-technology.at>
In-Reply-To: <a3ca03e82d9afad72346dc5b4ae251c7.squirrel@webmail.it-technology.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904181222.33869.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Saturday 18 April 2009 08:48:22 Peter Holik, vous avez écrit :
> > Hi Peter,
> >
> > Nice to see such a driver coming up!
>
> thanks
>
> > Le Friday 17 April 2009 16:10:24 Peter Holik, vous avez écrit :
> >> Signed-off-by: Peter Holik <peter@holik.at>
> >> ---
> >>  drivers/net/usb/Kconfig    |    7 +
> >>  drivers/net/usb/Makefile   |    2 +-
> >>  drivers/net/usb/intellon.c |  273
> >> ++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 281
> >> insertions(+), 1 deletions(-)
> >>  create mode 100644 drivers/net/usb/intellon.c
> >>
> >> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
> >> index 8ee2103..068faa5 100644
> >> --- a/drivers/net/usb/Kconfig
> >> +++ b/drivers/net/usb/Kconfig
> >> @@ -345,4 +345,11 @@ config USB_HSO
> >>  	  To compile this driver as a module, choose M here: the
> >>  	  module will be called hso.
> >>
> >> +config USB_NET_INTELLON
> >> +	tristate "Intellon PLC based usb adapter"
> >> +	depends on USB_USBNET
> >> +	help
> >> +	  Choose this option if you're using a PLC (Powerline Communications)
> >> +	  solution with an Intellon chip, like the "devolo dLan duo".
> >> +
> >
> > Please be more specific, i.e: using a USB-based PLC (...) solution.
> >
> > There might be support for PLC PHYs connected to a MII-bus in a near
> > future, even though they will not reside in drivers/net/usb/.
>
> What do you mean with the last sentence?

I mean that one might come up with a design that uses Intellon PLC PHY chips 
only with a custom MAC chip, not integrated MAC+PHY chips only, therefore a 
more specific naming is required, that's purely cosmetic though.

>
> >>  endmenu
> >> diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
> >> index 88a87ee..0fccfe9 100644
> >> --- a/drivers/net/usb/Makefile
> >> +++ b/drivers/net/usb/Makefile
> >> @@ -19,4 +19,4 @@ obj-$(CONFIG_USB_NET_CDC_SUBSET)	+= cdc_subset.o
> >>  obj-$(CONFIG_USB_NET_ZAURUS)	+= zaurus.o
> >>  obj-$(CONFIG_USB_NET_MCS7830)	+= mcs7830.o
> >>  obj-$(CONFIG_USB_USBNET)	+= usbnet.o
> >> -
> >> +obj-$(CONFIG_USB_NET_INTELLON)	+= intellon.o
> >
> > I would not name this intellon for the same reasons as explained below,
> > but rather int51x1.c since this driver will for instance not work with
> > HomePlug AV designs which use different Intellon integrated chips like
> > the 6000 and 6300 series.
>
> work in progress...

Cool :)

> Disagree, because i've taken "nibble" and "get_ethernet_addr" from
> cdc_ether.c to have the same code (the version of Jan was different).

Ok.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------

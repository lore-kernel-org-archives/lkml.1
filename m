Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbZLJUvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbZLJUvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 15:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbZLJUvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 15:51:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:54372 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508AbZLJUvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 15:51:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=srm+9KJFcXQzuNoVFEwmBNGd23g1+Llss5og2B6LN324IOC9Ty8aPZ/aRl755Bhs+p
         7fMRh213N5gjQ9Gm6TCYHtV90JKMBjN2lweDfGuf3BNhuLg76MGYC4dmTzx9PtYkQrjo
         2MDNr40VXO35fXdRQI9rCltKiDPQZ1wmtulGA=
MIME-Version: 1.0
In-Reply-To: <20091210165106.GA21502@nokia.com>
References: <20091202215442.GA30658@oksana.dev.rtsoft.ru>
	 <20091202225922.GA15568@oksana.dev.rtsoft.ru>
	 <20091203083958.GB31110@nokia.com>
	 <6ed0b2680912030255o57d7c46qb5ae1cfcb82e9976@mail.gmail.com>
	 <20091203110332.GO1361@nokia.com>
	 <6ed0b2680912100609g11706296qdbcea887dc3a5733@mail.gmail.com>
	 <20091210141830.GA10687@oksana.dev.rtsoft.ru>
	 <20091210142127.GB12526@nokia.com>
	 <20091210144411.GA13120@oksana.dev.rtsoft.ru>
	 <20091210165106.GA21502@nokia.com>
Date: Thu, 10 Dec 2009 22:51:06 +0200
Message-ID: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Grazvydas Ignotas <notasas@gmail.com>
To: felipe.balbi@nokia.com
Cc: ext Anton Vorontsov <avorontsov@ru.mvista.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 6:51 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
> Hi,
>
> On Thu, Dec 10, 2009 at 03:44:11PM +0100, ext Anton Vorontsov wrote:
>>
>> Yep. The only thing I'm afraid of is that once the driver is in,
>> then nobody will bother with improving it to do the right thing.
>> But an imperfect driver is better than none.
>
> I'm currently implementing the notifier part in a generic manner that would
> handle all transceivers (well, they would have to provide a some
> implementations for function pointers in struct otg_transceiver).
>
> Then drivers like twl4030-bci and musb_hdrc could register for notifications
> from the transceiver. I was thinking of notifying the following events:
>
> enum usb_xceiv_events {
>        USB_EVENT_NONE,         /* no events or cable disconnected */
>        USB_EVENT_VBUS,         /* vbus valid event */
>        USB_EVENT_ID,           /* id was grounded */
>        USB_EVENT_CHARGER,      /* usb dedicated charger */
>        USB_EVENT_ENUMERATED,   /* gadget driver enumerated */
> };
>
> for the USB_EVENT_ENUMERATED we could also pass the bMaxPower (in mA) field
> of the struct usb_configuration, then BCI (or bq24xxx for that matter) can
> configure that as input current for charging.
>
> USB_EVENT_ID is necessary because in most boards (at least the ones I've
> seen) the charging chip (bq24xxx) also plays the role as charge pump,
> sourcing vbus on OTG sessions.
>
> USB_EVENT_VBUS and USB_EVENT_CHARGER aren't necessary on all cases, but
> boards like RX-51 where it has a different transceiver for charger
> detection, it's necessary to have those two separated.
>
> If you guys have any comments already, please comment :-)
>
> I'll try to finish a prototype by tomorrow and try to send it as RFC.

Nice! Looking good, it seems this has everything BCI needs, will wait
for your code before updating BCI.

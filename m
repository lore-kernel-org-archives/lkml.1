Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZFSHur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZFSHur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbZFSHuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:50:39 -0400
Received: from n10.bullet.mail.mud.yahoo.com ([209.191.125.208]:40843 "HELO
	n10.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750728AbZFSHuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:50:39 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2009 03:50:39 EDT
X-Yahoo-Newman-Id: 348021.53801.bm@omp414.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AMKf8fFQjnrGDhHRRTGcE2lbf3eKQe45ucqljgwgMk4h54YIC/+S+IQsj8ZY7nQcGvpSztSRor9L/+Eh8bb1z2Xv2l4/Uovtlc3ZChlRqxO8LB+sAelme3AhfqqJOoSqwVm/og6f5NeOcgyJrZC46NAxtCZQSDnhcjsrHqgQRlE=  ;
X-YMail-OSG: S5Z3ixwVM1nlljMm35PeY0hzi93HzdePXhI3rBE5CA2MdxLvrH997cJsZO6op16S2q5b0n86A8I6I1jd0vXtME.o_0rf.I2T.bCDUZ4ZPShnATgVNxgA2I0xnBs7yQibS4Knc1FI.56Yas3WDkWpPh3EmP5lxTcfsIfplgESOxkJXE55_irnp02aURSZ7ZP3Y7G_xRep4cSifBQLYqSiTJLBwetU8rrmwK8NHSEPMrnSpNBMqqtreoNSdKu98Ys7hNQ.gilRJ6nY82KH
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 1/2 v2] at91/USB: Add USB drivers for at91sam9g45 series
Date: Fri, 19 Jun 2009 00:45:16 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com
References: <1244720355-10740-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1244720355-10740-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906190045.16496.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Nicolas Ferre wrote:
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -124,7 +124,7 @@ choice
>  
>  config USB_GADGET_AT91
>         boolean "Atmel AT91 USB Device Port"
> -       depends on ARCH_AT91 && !ARCH_AT91SAM9RL && !ARCH_AT91CAP9
> +       depends on ARCH_AT91 && !ARCH_AT91SAM9RL && !ARCH_AT91CAP9 && !ARCH_AT91SAM9G45
>         select USB_GADGET_SELECTED
>         help
>            Many Atmel AT91 processors (such as the AT91RM2000) have a
> @@ -143,7 +143,7 @@ config USB_AT91
>  config USB_GADGET_ATMEL_USBA
>         boolean "Atmel USBA"
>         select USB_GADGET_DUALSPEED
> -       depends on AVR32 || ARCH_AT91CAP9 || ARCH_AT91SAM9RL
> +       depends on AVR32 || ARCH_AT91CAP9 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
>         help
>           USBA is the integrated high-speed USB Device controller on
>           the AT32AP700x, some AT91SAM9 and AT91CAP9 processors from Atmel.

I understand the temptation, but please keep the gadget-side and host-side
support in separate patches.

If/when high speed OTG is supported on AT91 systems, that support would need
to touch both sides of the USB stack.  Otherwise, avoid doing that.




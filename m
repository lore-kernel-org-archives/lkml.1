Return-Path: <linux-kernel-owner+w=401wt.eu-S1422906AbXDRLx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422906AbXDRLx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 07:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422907AbXDRLx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 07:53:58 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:4101 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422906AbXDRLx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 07:53:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d9KIfvNa/PbPy+9RM6eQDozKbob1VDwpFYwEpdiXARWTI9KLFazzq0DmErZlJAnV8Ko6zeajx5HanKgbvl33MZEhiFZQrqbTg7uMc2aVSnm+hl2OYebH122zGM+65mLrA1iI2YrCelKuc28++T+uGZU7ZloUFj06Tby3Msvw0xA=
Message-ID: <ff1613620704180453t69585e21h5c31a4fe908d0aac@mail.gmail.com>
Date: Wed, 18 Apr 2007 17:23:57 +0530
From: "Madhusudhan c" <cr.madhusudhan@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: MMCv4 support (8-bit support missing)
Cc: linux-kernel@vger.kernel.org, philipl@overt.org
In-Reply-To: <4625DAFC.4000208@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>
	 <4625DAFC.4000208@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Perre/Philip,

> Feel free to add me as cc in the future if you want me to notice your mail ;)
Sure. In fact I looked around to find your email id and did not find
it. In future I will include you in cc.

> We haven't determined it as necessary, and as Philip commented, most (if not
> all) controllers cannot properly support the test.
The MMCA spec 4.1 has the below two lines of explaination in the Bus
testing procedure section.

1. "The data pattern sent by the host may optionally include a CRC16
checksum, which is ignored by the card."
2. "The reverse data pattern sent by the card may optionally include a
CRC16 checksum, which is ignored by the host."

I faced a simillar problem as philip mentioned on our hardware. I used
to see failures on CMD19. I used to get a "Data timeout" interrupt.
After speaking to our hardware folks, we got it working. The hardware
folks suggested me to do a soft reset of the data lines upon receiving
the DTO for CMD19.Our controller has a bit in the MMC registers to
soft reset the data lines. It solved the problem. So I expect their
may be simillar stuff on other controllers as well.

Kyung-ju Hyun from samsung had submitted a patch for MMCPlus support
long back, which had the bus testing procedure implemented and it
works fine. I am able to write and read the data pattern back
successfuly with his patch. I am not sure why his patch was not
integrated into the main line kernel.

Why should we be bothered about how controllers respond at the MMC
core level. We need to just implement what specification says and
leave the controller handling part to the controller driver. Am I
correct?

Regards,
Madhusudhan


On 4/18/07, Pierre Ossman <drzeus@drzeus.cx> wrote:
> Madhusudhan c wrote:
> > Hi Pierre/philip,
> >
>
> Hi Madhusudhan,
>
> Feel free to add me as cc in the future if you want me to notice your mail ;)
>
> > This is regarding the MMCv4 support that came in as part of the MMC
> > core of 2.6.20 linux kernel version.
> >
> > The high speed MMC cards can support 4-bit/8-bit transfers. The 8-bit
> > support seems to be missing from the MMCv4 support implemented by
> > Philip Langdale .
>
> As soon as hardware with specs is available we'll start hacking. :)
>
> > To support 8-bit transfers the core needs to implement "bus testing
> > procedure". This requires support for CMD19 and CMD14.
> >
> > Why is the support for bus testing procedure msiing from the MMCv4 support?
> >
>
> We haven't determined it as necessary, and as Philip commented, most (if not
> all) controllers cannot properly support the test.
>
> Rgds
> Pierre
>
>
>

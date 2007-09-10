Return-Path: <linux-kernel-owner+w=401wt.eu-S1760438AbXIJPLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438AbXIJPLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 11:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbXIJPLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 11:11:17 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:54323 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbXIJPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 11:11:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bvOCIrTGEJHJD9evNBMHQ+qI9g2SBi5SPutOSCBRN063Bx+o4borqgb8ftMGQZSp5SMyHM+yjepNS0svTG7y/r1RAs27c5XM118cM8z63YrDyvCje3C/TeBmcbyu5Mqn+A/hRrrJy81U+Ci5Z4ZcUdts59uw/hIcoo0GjdJL+1c=
Message-ID: <d120d5000709100811r520a7eeew7977739e08da85f9@mail.gmail.com>
Date: Mon, 10 Sep 2007 11:11:14 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [PATCH 2/3] Maple bus support for the Sega Dreamcast - keyboard support
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
In-Reply-To: <8b67d60709100728o699a7fefkc1cb610939fa12d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60709091001l3cd6adf6m2dab8e815f47435d@mail.gmail.com>
	 <20070909214438.79959ace@laptopd505.fenrus.org>
	 <8b67d60709091357k2bc0c673kef5716a97f07bd3a@mail.gmail.com>
	 <200709092350.47602.dtor@insightbb.com>
	 <8b67d60709100728o699a7fefkc1cb610939fa12d4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/07, Adrian McMenamin <dmitry.torokhov@gmail.com> wrote:
> On 10/09/2007, Dmitry Torokhov <dtor@insightbb.com> wrote:
> > Hi Adrian,
> >
>
> Thanks for the comments - will get on with this but....
>
>
> > > +     for (i = 0; i < NR_SCANCODES; i++)
> > > +             kbd->keycode[i] = dc_kbd_keycode[i];
> >
> > memcpy?
> >
>
> I see that other drivers use memcpy - and will happily convert over -
> but, out of interest, is there a reasopn why it is superior?
>

First and foremost it conveys the intent clearly - you are copying a
chunk of memory (namely a keymap) from one place to another - thus
memcpy. Plus it may produce smaller/faster code (but since it is not a
hot path this does not matter much).

> >
> > maple_device appears to be fully integrated in sysfs, please add:
> >        kbd->dev->dev.parent = &dev->dev;
> >
>
> The bus code already correctly ids the parent device (the above code
> would appear to assign the device as the device's parent
> incidentally). Is it wrong to make that assignment in the central bus
> code as opposed to the driver?
>

Here I want to set up sysfs relation for the newly created struct
input_dev which is a child of struct maple_dev. The central bus
(maple) code has no idea of input device existence, hasn't it? IOW we
need:

     input_dev->dev.parent = &maple_dev->dev;

-- 
Dmitry

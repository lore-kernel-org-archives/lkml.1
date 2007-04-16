Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbXDPVd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbXDPVd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbXDPVd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:33:28 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:33333 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbXDPVdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pK5yWmLPDJmujZoFhxD3tblCyIllTgftBU8Z+gTY+H0meuOeiMsNJUUjcjQsFaJyzZ2I6J/5LwzHtGK8D2N8VdIMKB3kOqyDteQG8uVyswgVIoSaJFsQp1yq6dObrlTuhxDaQ+IwAn1P8e07jX9fSqolfbkBB/5Iv9C0UHSwj1w=
Message-ID: <f383264b0704161433v1bcba3d1v46c0838fa93a79a5@mail.gmail.com>
Date: Mon, 16 Apr 2007 14:33:24 -0700
From: "Matt Reimer" <mattjreimer@gmail.com>
To: cbou@mail.ru
Subject: Re: [PATCH 6/7] [RFC] ds2760 battery driver
Cc: "Pavel Machek" <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, dwmw2@infradead.org
In-Reply-To: <20070416193518.GA3580@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070411232522.GF20095@zarina> <20070415194001.GF10097@ucw.cz>
	 <f383264b0704161214x168b36f4tdd9a074d604b36cb@mail.gmail.com>
	 <20070416193518.GA3580@zarina>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Anton Vorontsov <cbou@mail.ru> wrote:
> On Mon, Apr 16, 2007 at 12:14:27PM -0700, Matt Reimer wrote:
> >  The shifts (<< 3 and >> 5) are just to get the bits reassembled in the
> >  right positions. The multiplication by 5 and subtracting 1/8 is
> >  because (AFAIK) we can't do floating point multiplication in the
> >  kernel. I'm open to suggestions.
>
> Because we are in micro world now, divisions already replaced by
> multiplication. I.e.
>
>         /* DS2760 reports voltage in units of 4.88mV, but the battery class
>          * reports in units of uV, so convert by multiplying by 4880. */
>         di->voltage_raw = (di->raw[DS2760_VOLTAGE_MSB] << 3) |
>                           (di->raw[DS2760_VOLTAGE_LSB] >> 5);
>         di->voltage_uV = di->voltage_raw * 4880;
>
> As a side effect, now we're not losing any precision. :-)

That's a good way to solve the problem. :-)

> By the way. Matt, you're more familiar with ds2760 specs, could you
> enlighten me about "* 4" in this snippet?
>
> >       acr[0] = (di->full_active_mAh * 4) >> 8;
>                                       ^^^
> >       acr[1] = (di->full_active_mAh * 4) & 0xff;
>                                       ^^^
> >       if (w1_ds2760_write(di->w1_dev, acr,
> >                           DS2760_CURRENT_ACCUM_MSB, 2) < 2)
> >              printk(KERN_ERR "ACR reset failed\n");

The accumulated current register (acr) value is in units of 0.25 mAh,
so we have to multiply by 4 to convert from units of 1 mAh to 0.25
mAh.

Thanks for all your work on this Anton.

Matt

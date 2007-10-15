Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbXJORdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbXJORdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbXJORdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:33:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:60419 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbXJORde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:33:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iTHYXh/++cOL58zvQGRInKUm7OE7OfZQvo56A5cC7MYNvaMUEtSq2PFCxZgI6tUSN6KFa665AElU9er4LhZGRc9vfIYY1tq5EHsImcFE5HsskQ9j+om3OcFaVsVRFKnJcedPNsjVqveFM6fOt2lk7H6xRQgUQ7d6YEB8KTwfOms=
Message-ID: <d120d5000710151033u44df579fr82588a7a6c7065d@mail.gmail.com>
Date: Mon, 15 Oct 2007 13:33:31 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH 2/3] Input/Touchscreen Driver: add support AD7877 touchscreen driver
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC0F2B13C2@limkexm2.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <600D5CB4DFD93545BF61FF01473D11AC0F2B13C2@limkexm2.ad.analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 10/15/07, Hennerich, Michael <Michael.Hennerich@analog.com> wrote:
> >
> >> +
> >> +static int ad7877_read(struct device *dev, u16 reg)
> >> +{
> >> +       struct spi_device       *spi = to_spi_device(dev);
> >> +       struct ser_req          *req = kzalloc(sizeof *req,
> GFP_KERNEL);
> >
> >How many reads can happen at once? Maybe allocate 1 ser_req per
> >touchcsreen when creating it?
>
> ad7877_read_adc, ad7877_read and ad7877_write are just used by the sysfs
> hooks. Touchscreen samples are read by the kthread using a different
> message struct. So far each sysfs invocation got its own storage for the
> spi message, which then is handed over to the SPI bus driver.
> The SPI bus driver serializes transfers in a kthread.
>
> Two different processes could access the drivers sysfs hooks.
>
> Using one ser_req per touch screen could require additional locking?
> Things at is, looks pretty safe to me.
>

OK, fair enough.

-- 
Dmitry

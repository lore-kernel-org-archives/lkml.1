Return-Path: <linux-kernel-owner+w=401wt.eu-S1030614AbXCFXE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030614AbXCFXE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 18:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030636AbXCFXE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 18:04:57 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:56611 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030614AbXCFXE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 18:04:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V+Uwll027SwRAM7XXlDbqyiH6RklnyBqwfG6WUD307tox+oms08iltKA8NEjZ6d63KdVMbRUqZsQrLQdeWH0lGbkoAjCi0YkFy4mPKfNjUwInjkkOgI6G/fJDX3O8Wxqmp8VAPTyFbYUFbxStYGB9C71bsbFt63zS0V1ebuxqpI=
Message-ID: <8bd0f97a0703061504h78890fcexc10e97c026c41924@mail.gmail.com>
Date: Tue, 6 Mar 2007 18:04:56 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Cc: "Wu, Bryan" <bryan.wu@analog.com>, khali@linux-fr.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mhfan@ustc.edu
In-Reply-To: <20070306214301.GA5590@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1173164058.31825.16.camel@roc-desktop>
	 <20070306214301.GA5590@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > +static int __init i2c_bfin_twi_init(void)
> > +{
> > +     rc = request_irq(twi_iface.irq, bfin_twi_interrupt_entry, SA_INTERRUPT, "i2c-bfin-twi", &twi_iface);
> > +     if (rc) {
> > +             printk(KERN_ERR "i2c-bfin-twi: can't get IRQ %d !\n", twi_iface.irq);
> > +             return -ENODEV;
> > +     }
> > +
> > +     /* Set TWI internal clock as 10MHz */
> > +     bfin_write_TWI_CONTROL(((get_sclk() / 1024 / 1024 + 5) / 10) & 0x7F);
> > +
> > +     /* Set Twi interface clock as specified */
> > +     if (CONFIG_TWICLK_KHZ > 400)
> > +             bfin_write_TWI_CLKDIV((( 5*1024 / 400 ) << 8) | (( 5*1024 / 400 ) & 0xFF));
> > +     else
> > +             bfin_write_TWI_CLKDIV((( 5*1024 / CONFIG_TWICLK_KHZ ) << 8) | (( 5*1024 / CONFIG_TWICLK_KHZ ) & 0xFF));
> > +
> > +     /* Enable TWI */
> > +     bfin_write_TWI_CONTROL(bfin_read_TWI_CONTROL() | TWI_ENA);
> > +     SSYNC();
> > +
> > +     return i2c_add_adapter(p_adap);
>
> free_irq on error?

what error ?  do you mean i2c_add_adapter() ?
-mike

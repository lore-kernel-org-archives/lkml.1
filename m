Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYLVQXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYLVQXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 11:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbYLVQXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 11:23:36 -0500
Received: from mail.openmoko.org ([88.198.124.205]:33248 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbYLVQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 11:23:35 -0500
Date: Mon, 22 Dec 2008 21:53:01 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH V2 2/7] mfd: PCF50633 adc driver
Message-ID: <20081222162300.GC3073@fedora.yogi>
References: <20081218055618.31696.65002.stgit@cff.thadambail> <20081218055653.31696.4361.stgit@cff.thadambail> <494B831C.5050402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494B831C.5050402@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 11:18:52AM +0000, Jonathan Cameron wrote:
Hi Jonathan,

> 
> This is confusingly named. To my mind it is writing the setup
> to the device not reading it.
> 
> > +static void adc_read_setup(struct pcf50633 *pcf, int channel, int avg)
> > +{
> > +    channel &= PCF50633_ADCC1_ADCMUX_MASK;

Yes, right. Will change.

> This needs a bit more explanation. Particularly as the data
> sheet describes that accsw as 'for rationmetric measurement'.
> Also, seeing as I assume this is the only driver that can touch
> these registers and you don't change them else where, why can't
> they be in initial setup code rather than here? (probably a good
> reason, but be nice to have it document here!)

Yes, the for killing ratiometric measurement can be in _probe. But we
need to enable accsw everytime because it's turned off automatically 
once a conversion is complete - to save power.

> > +    /* kill ratiometric, but enable ACCSW biasing */
> > +    pcf50633_reg_write(pcf, PCF50633_REG_ADCC2, 0x00);
> > +    pcf50633_reg_write(pcf, PCF50633_REG_ADCC3, 0x01);
> > +
> > +    /* start ADC conversion on selected channel */
> > +    pcf50633_reg_write(pcf, PCF50633_REG_ADCC1, channel | avg |
> ...
> > +
> > +static void pcf50633_adc_irq(int irq, void *data)
> > +{
> > +    struct pcf50633_adc *adc = data;
> > +    struct pcf50633 *pcf = adc->pcf;
> > +    struct pcf50633_adc_request *req;
> > +    int head;
> > +    mutex_lock(&adc->queue_mutex);
> > +    head = adc->queue_head;
> > +
> > +    req = adc->queue[head];
> > +    if (WARN_ON(!req)) {
> > +        dev_err(pcf->dev, "pcf50633-adc irq: ADC queue empty!\n");
> > +        mutex_unlock(&adc->queue_mutex);
> > +        return;
> > +    }
> > +    adc->queue[head] = NULL;
> 
> Weird formatting?
>

Oops! Will fix.

Thank you for the review.

Balaji Rao

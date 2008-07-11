Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYGKIp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYGKIp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYGKIpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:45:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:6320 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYGKIpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lP0+YydX2o9+X8y7XK5+Hf2SLdh0jH94fLjUz9aCE1a+RDLKQvKrCiW4FkanYXfCDc
         JMDSE880gPWNG+aSAQMe7CsDbD5yDXVcD0WjDebslxKRq804/STl8zWfffPVrxlSlL3n
         8qpxC1OIUY9UktUo5VAw6UTzIMYOeUc6GP2D8=
Message-ID: <aec7e5c30807110145s1106bb2bs60026400390e3de3@mail.gmail.com>
Date: Fri, 11 Jul 2008 17:45:48 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] uio: uio_pdrv_genirq V2
Cc: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080710105850.GA3202@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080710035254.27378.18682.sendpatchset@rx1.opensource.se>
	 <20080710065639.GA16794@digi.com> <20080710105850.GA3202@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 7:58 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Thu, Jul 10, 2008 at 08:56:39AM +0200, Uwe Kleine-König wrote:
>> > +       ret = uio_register_device(&pdev->dev, priv->uioinfo);
>> > +       if (ret) {
>> > +               dev_err(&pdev->dev, "unable to register uio device\n");
>> > +               goto bad1;
>> > +       }
>> > +
>> > +       platform_set_drvdata(pdev, priv);
>> This should probably go before uio_register_device.  (Uups, this is an
>> issue for uio_pdrv, too.)
>
> Yes, because uio_register_device will enable the irq, and you might
> arrive in the handler without having your platform data in place.

I'd say that this is a non-issue.

Only uio_pdrv_genirq_remove() is using the platform data. This
remove() method won't be called if uio_pdrv_genirq_probe() returns
failure. The UIO subsystem is using uioinfo->priv which of course is
set up correctly already.

Thanks,

/ magnus

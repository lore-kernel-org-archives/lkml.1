Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbYGGT7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbYGGT7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYGGT6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:58:54 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:51231 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbYGGT6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:58:53 -0400
Date: Mon, 7 Jul 2008 22:02:51 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, sameo@openedhand.com,
       linux-kernel@vger.kernel.org, Daniel Ribeiro <wyrm@openezx.org>
Message-ID: <20080707200251.GA3449@datenfreihafen.org>
References: <20080707184000.411913919@datenfreihafen.org> <20080707184129.554483476@datenfreihafen.org> <74d0deb30807071221u4e216f76l479766925c903b5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74d0deb30807071221u4e216f76l479766925c903b5f@mail.gmail.com>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [Patch 06/10] mfd: PCAP driver for the Motorola EZX GSM mobile
	phones
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Mon, 2008-07-07 at 21:21, pHilipp Zabel wrote:
> On Mon, Jul 7, 2008 at 8:40 PM,  <stefan@datenfreihafen.org> wrote:
> > The PCAP Asic as present on EZX phones is a multi function device with voltage
> > regulators, irq expander, touch screen controller and audio codec.
> > It is connected to the processor via SPI, this driver provides read/write
> > functions to its registers and a irq demultiplexer.
> 
> Are the EZX phones expected to be the only linux devices with PCAP?

That is somewhat hard to predict as Motorola was not interested in helping us
with the driver for mainline and we never got datasheets or technical support.
>From what we have researched it seems that they use an antecessor of this chip
in older feature phones. As far as we know none of them runs linux.

> Otherwise I'd dislike the hardcoded IRQ numbers in the MFD driver.

So far it seems to be no problem. If there is a strong feeling to change this we
will of course work on that. Personally I would prefer to do this when new users
of this driver appear.

> The machine_is_xyz() calls inside ezx-pcap could be replaced with
> configuration via platform_data (have pcap_platform_data->cs_inverted,
> for example)

We had this before and it turned out as messy as this solution. We have one
machine file that supports up to 6 devices right now. So we would have to deal
with the same machine_is_xyz macros in the machine file.

We thought it would be better to let the driver handle this. Open for discussion
of course.

> > +#if 0
> > +#define DEBUGP(x, args...) printk(x, ## args)
> > +#else
> > +#define DEBUGP(x, args...)
> > +#endif
> 
> Could you remove the custom debug macros and use pr_debug (or even
> better, dev_dbg) instead?

Will do.

> > +static void __exit ezx_pcap_exit(void)
> > +{
> > +       return platform_driver_unregister(&ezxpcap_driver);
> > +}
> > +
> > +module_init(ezx_pcap_init);
> 
> Depending on what platform_devices depend on this, maybe use
> subsys_initcall here.

Ok, I'll need to look up on this to see if it is an option.

> > +module_exit(ezx_pcap_exit);
> 
> Why bother with module_exit when the Kconfig option is bool?

Well, matter of taste. :)

Taking care about cleanup is good style. Still you are right that it is useles
for the time being.

> > +#define PCAP_IRQ_USB4V         (1 << 6)        /* USB above 4volt???
> > +                                               called "USBDET_4V" in blob */
> 
> I assume that's for OTG operation. The VBUS voltage is valid from 4.4 V, and the
> PXA27x UDC controller has "Vbus valid 4.0 V" and "Vbus valid 4.4 V" interrupts

ok

> > +       /*  set core voltage */
> > +       ezx_pcap_set_sw(SW1, SW_VOLTAGE, SW_VOLTAGE_1250);
> 
> Btw, did you see the voltage regulator framework that is in linux-next?

Heard of it, but not read the code yet. It's on my list. I just a bit hesitant
to base on code that is not in mainline yet. But -next should be ok.

> > -
> > +       platform_device_register(&ezx_pcap_device);
> >        platform_add_devices(devices, ARRAY_SIZE(devices));
> 
> You could put ezx_pcap_device into the beginning of devices[].

Duh, will fix.

I send out an updated patch tomorrow. Need some sleep now.

Thanks for the feedback.

regards
Stefan Schmidt

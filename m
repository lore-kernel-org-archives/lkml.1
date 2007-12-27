Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbXL0SUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbXL0SUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXL0STz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:19:55 -0500
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203]:52279 "EHLO
	nebuchadnezzar.smejdil.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbXL0STy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:19:54 -0500
From: CIJOML <cijoml@volny.cz>
To: "Kim Sandberg" <ksan@saunalahti.fi>, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] SATELCO EasyWatch PCI DVB-T
Date: Thu, 27 Dec 2007 19:19:31 +0100
User-Agent: KMail/1.9.7
References: <72cfaa200711230332h3f21f092ua7f09519e83e74f0@mail.gmail.com> <72cfaa200711231313n61fe8110t71322b31485f8006@mail.gmail.com>
In-Reply-To: <72cfaa200711231313n61fe8110t71322b31485f8006@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712271919.32997.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

I own same card as you - do you also have interrupts errors while playing 
stream?

notas:/home/cijoml# cat /proc/interrupts
           CPU0
  0:    2954366    XT-PIC-XT        timer
  1:      21558    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  4:      63639    XT-PIC-XT        irda0
  5:          3    XT-PIC-XT        parport0
  6:          5    XT-PIC-XT        floppy
  8:          2    XT-PIC-XT        rtc
  9:         71    XT-PIC-XT        acpi
 10:     792694    XT-PIC-XT        yenta, yenta, ehci_hcd:usb2, 
uhci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7, ohci_hcd:usb8, ohci1394, wifi0, 
Intel 82801DB-ICH4, Intel 82801DB-ICH4 Modem
 11:         16    XT-PIC-XT        ehci_hcd:usb1, uhci_hcd:usb3, 
uhci_hcd:usb4
 12:    1243068    XT-PIC-XT        i8042
 14:      74473    XT-PIC-XT        libata
 15:     139877    XT-PIC-XT        libata
NMI:          0
LOC:    3331447
ERR:          20354
^^^^^^^^^^^^^^^^^^^^^^^^
MIS:          0

counter increases ONLY when card really plays stream, if only plugged, this 
counter is not increasing

Can you please verify?

Michal


Dne pá 23. listopadu 2007 Kim Sandberg napsal(a):
> Hi.
>
> Replying to myself.
>
> Created a simple patch and I got the card working. Seems to work ok
> under vdr with 1h of recording done.
> I got no idea of the names that should be used so just picked something
> similar.
>
> ---------------------------
> diff -u -r orig.v4l-dvb/linux/drivers/media/dvb/ttpci/budget-av.c
> v4l-dvb/linux/drivers/media/dvb/ttpci/budget-av.c
> --- orig.v4l-dvb/linux/drivers/media/dvb/ttpci/budget-av.c
> 2007-11-23 22:08:25.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/dvb/ttpci/budget-av.c   2007-11-23
> 21:59:09.000000000 +0200
> @@ -913,6 +913,7 @@
>  #define SUBID_DVBT_KNC1_PLUS           0x0031
>  #define SUBID_DVBT_KNC1                        0x0030
>  #define SUBID_DVBT_CINERGY1200         0x1157
> +#define SUBID_DVBT_EASYWATCH           0x003a
>
>  static void frontend_init(struct budget_av *budget_av)
>  {
> @@ -1021,6 +1022,7 @@
>         case SUBID_DVBT_KNC1:
>         case SUBID_DVBT_KNC1_PLUS:
>         case SUBID_DVBT_CINERGY1200:
> +       case SUBID_DVBT_EASYWATCH:
>                 budget_av->reinitialise_demod = 1;
>                 fe = dvb_attach(tda10046_attach, &philips_tu1216_config,
>                                      &budget_av->budget.i2c_adap);
> @@ -1248,6 +1250,7 @@
>  MAKE_BUDGET_INFO(satewps, "Satelco EasyWatch DVB-S", BUDGET_KNC1S);
>  MAKE_BUDGET_INFO(satewplc, "Satelco EasyWatch DVB-C", BUDGET_KNC1CP);
>  MAKE_BUDGET_INFO(satewcmk3, "Satelco EasyWatch DVB-C MK3",
> BUDGET_KNC1C_MK3); +MAKE_BUDGET_INFO(satewt, "Satelco EasyWatch DVB-T",
> BUDGET_KNC1C_MK3); MAKE_BUDGET_INFO(knc1sp, "KNC1 DVB-S Plus",
> BUDGET_KNC1SP);
>  MAKE_BUDGET_INFO(knc1cp, "KNC1 DVB-C Plus", BUDGET_KNC1CP);
>  MAKE_BUDGET_INFO(knc1cmk3, "KNC1 DVB-C MK3", BUDGET_KNC1C_MK3);
> @@ -1272,6 +1275,7 @@
>         MAKE_EXTENSION_PCI(satewps, 0x1894, 0x001b),
>         MAKE_EXTENSION_PCI(satewplc, 0x1894, 0x002a),
>         MAKE_EXTENSION_PCI(satewcmk3, 0x1894, 0x002c),
> +       MAKE_EXTENSION_PCI(satewt, 0x1894, 0x003a),
>         MAKE_EXTENSION_PCI(knc1c, 0x1894, 0x0020),
>         MAKE_EXTENSION_PCI(knc1cp, 0x1894, 0x0021),
>         MAKE_EXTENSION_PCI(knc1cmk3, 0x1894, 0x0022),
> ----------------------------
>
> > Hi.
> >
> > I bought a Satelco dvb-t card and it doesnt seem to be added to budget
> > drivers.
> >
> > kudzu -p tells me this:
> >
> > class: CAPTURE
> > bus: PCI
> > detached: 0
> > desc: "Philips Semiconductors SAA7146"
> > vendorId: 1131
> > deviceId: 7146
> > subVendorId: 1894
> > subDeviceId: 003a
> > pciType: 1
> > pcidom:    0
> > pcibus:  0
> > pcidev:  a
> > pcifn:  0
> >
> >
> > I couldnt find the 003a device id any of the sources.
> >
> > Any hint what to try as many of the similar cards are working ok.
> >
> > Card info:
> > http://www.dvbshop.net/product_info.php/info/p312_SATELCO-EasyWatch-PCI-D
> >VB-T--Basic-Edition-.html
> >
> >
> > Br,
> > Kim Sandberg
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



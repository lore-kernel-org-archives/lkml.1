Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbZAUIZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbZAUIZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZAUIZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:25:05 -0500
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:46516 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755318AbZAUIZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:25:04 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 03:25:03 EST
Message-ID: <4976DA3D.7050201@teltonika.lt>
Date: Wed, 21 Jan 2009 10:18:05 +0200
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Michael Bramer <michael@debsupport.de>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] drivers/serial/8250_pci.c (add support for '8-port RS-232
 MIC-3620 from advantech'
References: <20090118135359.GA3087@deb-support.de> <20090119145101.GA16732@ports.donpac.ru> <20090119235122.GE21026@deb-support.de> <20090120151216.GB16732@ports.donpac.ru> <20090121075212.GA18485@deb-support.de>
In-Reply-To: <20090121075212.GA18485@deb-support.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Bramer wrote:
> On Tue, Jan 20, 2009 at 06:12:16PM +0300, Andrey Panin wrote:
>> On 019, 01 19, 2009 at 11:51:22PM +0000, Michael Bramer wrote:
>>> On Mon, Jan 19, 2009 at 05:51:01PM +0300, Andrey Panin wrote:
>>>> On 018, 01 18, 2009 at 01:53:59PM +0000, Michael Bramer wrote:
>>>>> +        * ADVANTECH
>>>>> +        */
>>>>> +       {
>>>>> +               .vendor         = PCI_VENDOR_ID_ADVANTECH,
>>>>> +               .device         = PCI_DEVICE_ID_ADVANTECH_PCI3620,
>>>>> +               .subvendor      = PCI_DEVICE_ID_ADVANTECH_PCI3620,
>>>>> +               .subdevice      = PCI_ANY_ID,
>>>>> +               .setup          = pci_default_setup,
>>>>> +       },
>>>>> +       /*
>>>>>          * AFAVLAB cards - these may be called via parport_serial
>>>>>          *  It is not clear whether this applies to all products.
>>>>>          */
>>>> This part is not needed at all, pci_default_setup() will be used by default.
>>> ok. I don't test this. But you are right. The last entry in
>>> pci_serial_quirks should catch it. 
>>>
>>> Should I post a new patch, without this 10 lines?
>> Yes and add Signed-off-by: line please.
> 
> 
> the new patch:
> --------------
> This Patch add the device information for the 
> MIC-3620 8-port RS-232 cPCI card from Advantech Co. Ltd.
> 
> Signed-off-by: Michael Bramer <grisu@deb-support.de>
> --- a/drivers/serial/8250_pci.c
> +++ b/drivers/serial/8250_pci.c
> @@ -31,6 +31,7 @@
>  #include "8250.h"
> 
>  #undef SERIAL_DEBUG_PCI
> +#define SERIAL_DEBUG_PCI

NAK.

>  /*
>   * init function returns:
> @@ -768,6 +769,8 @@
>  #define PCI_SUBDEVICE_ID_OCTPRO422     0x0208
>  #define PCI_SUBDEVICE_ID_POCTAL232     0x0308
>  #define PCI_SUBDEVICE_ID_POCTAL422     0x0408
> +#define PCI_VENDOR_ID_ADVANTECH         0x13fe
> +#define PCI_DEVICE_ID_ADVANTECH_PCI3620 0x3620
> 
>  /*
>   * Master list of serial port init/setup/exit quirks.
> @@ -2041,6 +2054,9 @@
>  #endif
> 
>  static struct pci_device_id serial_pci_tbl[] = {
> +       {       PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI3620,
> +               0x3620, PCI_ANY_ID, 0, 0,
> +               pbn_b2_8_921600 },
>         {       PCI_VENDOR_ID_V3, PCI_DEVICE_ID_V3_V960,
>                 PCI_SUBVENDOR_ID_CONNECT_TECH,
>                 PCI_SUBDEVICE_ID_CONNECT_TECH_BH8_232, 0, 0,
> --------------
> 
> Gruss
> Grisu

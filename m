Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbXLAShz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbXLAShz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXLAShm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:37:42 -0500
Received: from smtp112.plus.mail.re1.yahoo.com ([69.147.102.75]:43620 "HELO
	smtp112.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752686AbXLAShl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:37:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=Vs2AeOHdoR9RZvTwJ6fEAkLpNvgElkpX7g/FBMxckkQyWo9O/hPJclF7g7A5xWtuIX4BZ6g3epuETrwAf7ouNl2ICm0Y8D/yyymam7wS64ICyFtLcTKIE+asvBJ77InhvfLNIqokh7b500j2g6UAC9VpmP/eYm4l0sCMF688tAk=  ;
X-YMail-OSG: k_L5YRYVM1nb.Tz_HSmIs16D8k9GVLxL0rDeydWyQOP16u5hWPxFz.RMOS1ybxzxN79sTDhB7w--
Date: Sat, 1 Dec 2007 19:36:53 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Jaime Velasco Juan <jsagarribay@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       Rui Santos <rsantos@grupopie.com>, Pete Zaitcev <zaitcev@redhat.com>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] USB: option: Bind to the correct interface of the
	Huawei E220
Message-ID: <20071201183653.GA6528@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Jaime Velasco Juan <jsagarribay@gmail.com>,
	Oliver Neukum <oliver@neukum.org>,
	Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
	Rui Santos <rsantos@grupopie.com>,
	Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
	preining@logic.at, kristoffer.ericson@gmail.com,
	drussell@redhat.com, linux-kernel@vger.kernel.org, greg@kroah.com
References: <20071128161305.b01167b3.zaitcev@redhat.com> <20071129150550.86453nubw8i5xi68@webmail.tugraz.at> <20071129185339.GA10445@singular.local> <200711300023.08999.oliver@neukum.org> <20071130163011.GA4223@singular.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071130163011.GA4223@singular.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 04:30:11PM +0000, Jaime Velasco Juan wrote:
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> Signed-off-by: Jaime Velasco Juan <jsagarribay@gmail.com>
> ---
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index a18659e..352c94c 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -158,8 +158,8 @@ static struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_NETWORK) },
>  	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
> -	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
> -	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS, 0xff, 0xff, 0xff) },
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1100) }, /* Novatel Merlin XS620/S640 */
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1110) }, /* Novatel Merlin S620 */
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1120) }, /* Novatel Merlin EX720 */
> -
yep, this one fixes the same problem here. Here's lsusb -v of my huawei modem:

Bus 001 Device 007: ID 12d1:1003  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x12d1 
  idProduct          0x1003 
  bcdDevice            0.00
  iManufacturer           1 HUAWEI Technologies
  iProduct                2 HUAWEI Mobile
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           85
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              3 Data Interface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval             128
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              3 Data Interface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)

-- 
Regards/Gruﬂ,
    Boris.

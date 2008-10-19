Return-Path: <linux-kernel-owner+w=401wt.eu-S1751974AbYJSTIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbYJSTIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 15:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYJSTIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 15:08:07 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:51644 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYJSTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 15:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W+hotVWB9jFuq6MTewazMtRrO6mVjs6fvBE93Dkn5b2TwtY9SmUj/1palfp4/1eCC5
         tTIlu+bhURSOWmBApWXAPII60xFH1HZ9Psb1iAH18WcLWU3DtglfifgiiJpaKMppkIPU
         1DzioHY8uA4W+t1W7twXaXNgbiI5sbU+CmgHw=
Message-ID: <dd18b0c30810191208p62bc8b1eub53b79de2d2d6261@mail.gmail.com>
Date: Sun, 19 Oct 2008 12:08:01 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/2] HID: add hid_type
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Steven Noonan" <steven@uplinklabs.net>,
       "Sven Anders" <anders@anduras.de>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       linux-bluetooth@vger.kernel.org
In-Reply-To: <1224425749-22652-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224425749-22652-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 7:15 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Add type to the hid structure to distinguish to which device type
> (mouse/kbd) we are talking to. Needed for per device type ignore
> list support.
>
> Note: this patch leaves the type as unknown for bluetooth devices,
> there is not support for this in the hidp code.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/hid/usbhid/hid-core.c |    8 ++++++++
>  include/linux/hid.h           |    7 +++++++
>  2 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 1d3b8a3..20617d8 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -972,6 +972,14 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
>        hid->vendor = le16_to_cpu(dev->descriptor.idVendor);
>        hid->product = le16_to_cpu(dev->descriptor.idProduct);
>        hid->name[0] = 0;
> +       switch (intf->cur_altsetting->desc.bInterfaceProtocol) {
> +       case USB_INTERFACE_PROTOCOL_KEYBOARD:
> +               hid->type = HID_TYPE_KEYBOARD;
> +               break;
> +       case USB_INTERFACE_PROTOCOL_MOUSE:
> +               hid->type = HID_TYPE_MOUSE;
> +               break;
> +       }
>
>        if (dev->manufacturer)
>                strlcpy(hid->name, dev->manufacturer, sizeof(hid->name));
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index f13bca2..36a3953 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -417,6 +417,12 @@ struct hid_input {
>        struct input_dev *input;
>  };
>
> +enum hid_type {
> +       HID_TYPE_UNKNOWN = 0,
> +       HID_TYPE_MOUSE,
> +       HID_TYPE_KEYBOARD
> +};
> +
>  struct hid_driver;
>  struct hid_ll_driver;
>
> @@ -431,6 +437,7 @@ struct hid_device {                                                 /* device report descriptor */
>        __u32 vendor;                                                   /* Vendor ID */
>        __u32 product;                                                  /* Product ID */
>        __u32 version;                                                  /* HID version */
> +       enum hid_type type;                                             /* device type (mouse, kbd, ...) */
>        unsigned country;                                               /* HID country */
>        struct hid_report_enum report_enum[HID_REPORT_TYPES];
>
> --
> 1.6.0.2
>
>

O.k. reverted the old patch and
applied the two new ones.
appletouchpad is working;
I didn't use patch -p1,
just manually applied the two.

-- 
Justin P. Mattock

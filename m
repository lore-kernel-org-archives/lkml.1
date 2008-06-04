Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYFDNW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYFDNW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYFDNVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:21:55 -0400
Received: from styx.suse.cz ([82.119.242.94]:39670 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751936AbYFDNVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:21:53 -0400
Date: Wed, 4 Jun 2008 15:21:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 06/10] HID: move logitech report quirks
In-Reply-To: <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
Message-ID: <Pine.LNX.4.64.0806041520140.10085@jikos.suse.cz>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Jiri Slaby wrote:

>  static const struct hid_device_id hid_blacklist[] = {
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2) },
>  	{ }
>  };

This shouldn't be needed as soon as the userspace supports the proper 
module autoloading, right?

> +#define LOGITECH_RDESC	0x1
> +
> +/*
> + * Certain Logitech keyboards send in report #3 keys which are far
> + * above the logical maximum described in descriptor. This extends
> + * the original value of 0x28c of logical maximum to 0x104d
> + */
> +static void lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
> +		unsigned int rsize)
> +{
> +	if (rsize >= 90 && rdesc[83] == 0x26
> +			&& rdesc[84] == 0x8c
> +			&& rdesc[85] == 0x02) {
> +		dev_info(&hdev->dev, "fixing up Logitech keyboard report "
> +				"descriptor\n");
> +		rdesc[84] = rdesc[89] = 0x4d;
> +		rdesc[85] = rdesc[90] = 0x10;
> +	}
> +}
> +
> +static const struct hid_device_id lg_devices[] = {
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER),
> +		.driver_data = LOGITECH_RDESC },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER),
> +		.driver_data = LOGITECH_RDESC },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2),
> +		.driver_data = LOGITECH_RDESC },
> +	{ }

You set the LOGITECH_RDESC flag here, but it is then never used anywhere. 
I guess that your original intent was to check for this flag in 
lg_report_fixup(), right?

Thanks,

-- 
Jiri Kosina
SUSE Labs

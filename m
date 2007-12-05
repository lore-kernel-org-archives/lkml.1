Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbXLEQeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbXLEQeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXLEQem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:34:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbXLEQek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:34:40 -0500
Date: Wed, 5 Dec 2007 08:34:23 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Jaime Velasco Juan <jsagarribay@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       Rui Santos <rsantos@grupopie.com>, linux-usb@vger.kernel.org,
       preining@logic.at, kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org, greg@kroah.com, zaitcev@redhat.com
Subject: Re: [PATCH] USB: option: Bind to the correct interface of the
 Huawei E220
Message-Id: <20071205083423.ca6ef199.zaitcev@redhat.com>
In-Reply-To: <20071130163011.GA4223@singular.local>
References: <20071128161305.b01167b3.zaitcev@redhat.com>
	<20071129150550.86453nubw8i5xi68@webmail.tugraz.at>
	<20071129185339.GA10445@singular.local>
	<200711300023.08999.oliver@neukum.org>
	<20071130163011.GA4223@singular.local>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 16:30:11 +0000, Jaime Velasco Juan <jsagarribay@gmail.com> wrote:

> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> -	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
> -	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS, 0xff, 0xff, 0xff) },

Looks good to me, shorter than my patch, has no duplication, allows to
use the storage, looks like a winner. Unfortunately, it leaves ub for dead,
because ub cannot invoke the necessary initializer unless we move it to
libusual. But oh well, I'll think about it.

Took me this long to test because I had to ask kind people in England
to replug the modem.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>

-- Pete

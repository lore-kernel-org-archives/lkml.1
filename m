Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbYEKXGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbYEKXGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 19:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756969AbYEKXFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 19:05:54 -0400
Received: from senator.holtmann.net ([87.106.208.187]:33170 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbYEKXFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 19:05:53 -0400
Subject: Re: [PATCH 2/9] HID: make a bus from hid code
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, akpm@linux-foundation.org,
       Jiri Slaby <jslaby@suse.cz>
In-Reply-To: <1210536043-19812-2-git-send-email-jirislaby@gmail.com>
References: <1210536043-19812-1-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-2-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain
Date: Mon, 12 May 2008 01:05:58 +0200
Message-Id: <1210547158.16390.28.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> Make a bus from hid core. This is the first step for converting all the
> quirks and separate almost-drivers into real drivers attached to this bus.
> 
> It's implemented to change behaviour in very tiny manner, so that no driver
> needs to be changed this time.
> 
> Also add generic drivers for both usb and bt into usbhid or hidp
> respectively which will bind all non-blacklisted device. Those blacklisted
> will be either grabbed by special drivers or by nobody if they are broken at
> the very rude base.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

<snip>
 
> +static const struct hid_device_id hid_generic_bt_ids[] = {
> +	{ HID_BT_DEVICE(HID_ANY_ID, HID_ANY_ID) },
> +	{ }
> +};

please rename it to hidp_table[].

Also can we do HID_BLUETOOTH_DEVICE() here. Since the bus constant is
called BUS_BLUETOOTH. Please don't shortcut it.

> +static struct hid_driver hid_generic_bt = {
> +	.name = "hid-generic-bt",
> +	.id_table = hid_generic_bt_ids,
> +};

And this one to hidp_driver instead of hid_generic_bt.

Also the name "hid-generic-bt" is not okay. Call it "hidp" since that is
the driver name. An alternative would be "hid-bluetooth". I don't like
the "generic" part and we never used the shortcut "bt" in any sysfs
visible file.

Do we really need the "hid-" prefix here. Since it is on the HID bus
anyway, we can leave the magic details to the driver model and simply
call it "bluetooth".

Other than that:

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel



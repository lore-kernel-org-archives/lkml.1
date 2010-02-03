Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab0BCOPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:15:31 -0500
Received: from senator.holtmann.net ([87.106.208.187]:36762 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab0BCOPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:15:30 -0500
Subject: Re: [PATCH 1/3] HID: make raw reports possible for both feature
 and output reports
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Bastien Nocera <hadess@hadess.net>, Michael Poole <mdpoole@troilus.org>,
       "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1002031348450.15395@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	 <1264783166.29532.5302.camel@localhost.localdomain>
	 <87iqakifm8.fsf@troilus.org>
	 <1264860663.29532.7887.camel@localhost.localdomain>
	 <87bpg7glf7.fsf@troilus.org>
	 <1265190440.32444.8417.camel@localhost.localdomain>
	 <alpine.LNX.2.00.1002031202040.15395@pobox.suse.cz>
	 <alpine.LNX.2.00.1002031343500.15395@pobox.suse.cz>
	 <alpine.LNX.2.00.1002031348450.15395@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 06:14:38 -0800
Message-ID: <1265206478.31341.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> In commit 2da31939a42 ("Bluetooth: Implement raw output support for HIDP
> layer"), support for Bluetooth hid_output_raw_report was added, but it
> pushes the data to the intr socket instead of the ctrl one. This has been
> fixed by 6bf8268f9a91f1 ("Bluetooth: Use the control channel for raw HID reports")
> 
> Still, it is necessary to distinguish whether the report in question should be
> either FEATURE or OUTPUT. For this, we have to extend the generic HID API,
> so that hid_output_raw_report() callback provides means to specify this
> value so that it can be passed down to lower level hardware drivers (currently
> Bluetooth and USB).
> 
> Based on original patch by Bastien Nocera <hadess@hadess.net>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/hidraw.c          |    2 +-
>  drivers/hid/usbhid/hid-core.c |    5 +++--
>  include/linux/hid.h           |    2 +-
>  net/bluetooth/hidp/core.c     |   13 ++++++++++---
>  4 files changed, 15 insertions(+), 7 deletions(-)

Acked-by: Marcel Holtmann <marcel@holtmann.org>
 
> -static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count)
> +static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count,
> +		unsigned char report_type)
>  {
> -	if (hidp_send_ctrl_message(hid->driver_data,
> -			HIDP_TRANS_SET_REPORT | HIDP_DATA_RTYPE_FEATURE,
> +	if (report_type == HID_FEATURE_REPORT)
> +		report_type = HIDP_TRANS_SET_REPORT | HIDP_DATA_RTYPE_FEATURE;
> +	else if (report_type == HID_OUTPUT_REPORT)
> +		report_type = HIDP_TRANS_DATA | HIDP_DATA_RTYPE_OUPUT;
> +	else
> +		return -EINVAL;

If you wanna be a little bit more readable, then using a switch
statement helps instead of else if. Just my 2 cents.

Regards

Marcel



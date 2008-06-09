Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbYFIKl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbYFIKl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbYFIKlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:41:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:61732 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759280AbYFIKlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:41:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=HZY7t1Vz8BOdwxMOWdvCuK4LEB5rl8TvEjBIp/VbaK5s6dzZW5RRmbgSKW+iCuEH2P
         F7BaqoM/hWLxKNkCSdoOwpM6FCuHHhUGEUP796JhdSH0eCHW3vcPARh9SLFVeXf3X3Aj
         OI9RomGAJcpQ6/f+gDPFwB6k3pujidBEeWfeA=
Message-ID: <484D08AA.1080300@gmail.com>
Date: Mon, 09 Jun 2008 12:40:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com
Subject: Re: [PATCH 08/10] HID: move apple quirks
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com> <1210931362-18422-2-git-send-email-jirislaby@gmail.com> <1210931362-18422-3-git-send-email-jirislaby@gmail.com> <1210931362-18422-4-git-send-email-jirislaby@gmail.com> <1210931362-18422-5-git-send-email-jirislaby@gmail.com> <1210931362-18422-6-git-send-email-jirislaby@gmail.com> <1210931362-18422-7-git-send-email-jirislaby@gmail.com> <1210931362-18422-8-git-send-email-jirislaby@gmail.com> <Pine.LNX.4.64.0806041610240.10085@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0806041610240.10085@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2008 04:13 PM, Jiri Kosina wrote:
> On Fri, 16 May 2008, Jiri Slaby wrote:
> 
> 
>> +static int apple_probe(struct hid_device *hdev,
>> +		const struct hid_device_id *id)
>> +{
>> +	unsigned long quirks = id->driver_data;
>> +	struct apple_sc *asc;
>> +	int ret;
>> +
>> +	/* return something else or move to hid layer? device will reside
>> +	   allocated */
>> +	if (id->bus == BUS_USB && (id->driver_data & APPLE_IGNORE_MOUSE) &&
>> +			to_usb_interface(hdev->dev.parent)->cur_altsetting->
>> +			desc.bInterfaceProtocol == USB_INTERFACE_PROTOCOL_MOUSE)
>> +		return -ENODEV;
>> +
>> +	asc = kzalloc(sizeof(*asc), GFP_KERNEL);
>> +	if (asc == NULL) {
>> +		dev_err(&hdev->dev, "can't alloc apple descriptor\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	hid_set_drvdata(hdev, asc);
>> +
>> +	if (quirks & APPLE_HIDDEV)
>> +		hdev->quirks |= HID_QUIRK_HIDDEV;
>> +	if (quirks & APPLE_IGNORE_HIDINPUT)
>> +		hdev->quirks |= HID_QUIRK_IGNORE_HIDINPUT;
>> +
>> +	ret = hid_parse(hdev);
>> +	if (ret) {
>> +		dev_err(&hdev->dev, "parse failed\n");
>> +		goto err_free;
>> +	}
>> +
>> +	ret = hid_hw_start(hdev);
>> +	if (ret) {
>> +		dev_err(&hdev->dev, "hw start failed\n");
>> +		goto err_free;
>> +	}
>> +
>> +	return 0;
>> +err_free:
>> +	kfree(asc);
>> +	return ret;
>> +}
> 
> Hi Jiri,
> 
> you don't seem to set asc->quirks anywhere, but the rest of the code is 
> testing this flag. Is something like
> 
> 	asc->quirks = id->driver_data;
> 
> missing in the _probe routine?

Blah, good catch! Do you want me to post a patch, or will you fix this on your own?

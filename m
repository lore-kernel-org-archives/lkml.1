Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbYFIKfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbYFIKfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759268AbYFIKez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:34:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:6003 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189AbYFIKey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=B+klKjCu1XJGzJ82xiDdavn8xz1zqGNQIJUNAHr7gGxXjMS1hu/grdQ6ppvOG1jTh6
         qCqnqVhWJzMauSdcRbrgJN/qkk1ozULx2z9prnv43yuav+oVW33aNAl5mszF3b43dDjM
         4ScfOUTTFw8DdafqR/n1kNvcMVPbWZwO2wD8M=
Message-ID: <484D070E.9050707@gmail.com>
Date: Mon, 09 Jun 2008 12:33:50 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com
Subject: Re: [PATCH 06/10] HID: move logitech report quirks
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com> <1210931362-18422-2-git-send-email-jirislaby@gmail.com> <1210931362-18422-3-git-send-email-jirislaby@gmail.com> <1210931362-18422-4-git-send-email-jirislaby@gmail.com> <1210931362-18422-5-git-send-email-jirislaby@gmail.com> <1210931362-18422-6-git-send-email-jirislaby@gmail.com> <Pine.LNX.4.64.0806041520140.10085@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0806041520140.10085@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2008 03:21 PM, Jiri Kosina wrote:
> On Fri, 16 May 2008, Jiri Slaby wrote:
> 
>>  static const struct hid_device_id hid_blacklist[] = {
>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2) },
>>  	{ }
>>  };
> 
> This shouldn't be needed as soon as the userspace supports the proper 
> module autoloading, right?

This is needed to tell generic drivers not to bind these, its' generic 
blacklist. I have no idea how this could be done better with current drivers/base/.

>> +#define LOGITECH_RDESC	0x1
>> +
>> +/*
>> + * Certain Logitech keyboards send in report #3 keys which are far
>> + * above the logical maximum described in descriptor. This extends
>> + * the original value of 0x28c of logical maximum to 0x104d
>> + */
>> +static void lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
>> +		unsigned int rsize)
>> +{
>> +	if (rsize >= 90 && rdesc[83] == 0x26
>> +			&& rdesc[84] == 0x8c
>> +			&& rdesc[85] == 0x02) {
>> +		dev_info(&hdev->dev, "fixing up Logitech keyboard report "
>> +				"descriptor\n");
>> +		rdesc[84] = rdesc[89] = 0x4d;
>> +		rdesc[85] = rdesc[90] = 0x10;
>> +	}
>> +}
>> +
>> +static const struct hid_device_id lg_devices[] = {
>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER),
>> +		.driver_data = LOGITECH_RDESC },
>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER),
>> +		.driver_data = LOGITECH_RDESC },
>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2),
>> +		.driver_data = LOGITECH_RDESC },
>> +	{ }
> 
> You set the LOGITECH_RDESC flag here, but it is then never used anywhere. 
> I guess that your original intent was to check for this flag in 
> lg_report_fixup(), right?

I assumed use of these in the second round (see my previous email) :). Anyway 
they are useless now.

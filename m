Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYKHORP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYKHORP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 09:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYKHOQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 09:16:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:60664 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbYKHOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 09:16:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=LZXa9s61urDtn9Cs3gGJB46ksxjbAhLUq/D/YDQ4JFuQ5BdhXefTs9m+3X7PCaVP9+
         rJf4UuSyIj3T14PouTW4JShdNWFxEjy4gQDo1/gkFaTwa9I5A9Zbf31stNafx5oJLOTb
         oYz6PVxJqlWMhBbXyGFAo60uHo6KYF1M7Xcws=
Message-ID: <49159F54.8090500@gmail.com>
Date: Sat, 08 Nov 2008 15:16:52 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Adam Nielsen <a.nielsen@shikadi.net>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: hid class and sysfs/hwmon
References: <490FFF1B.6050300@shikadi.net> <4910C32F.9060204@gmail.com> <49152F4E.5040003@shikadi.net>
In-Reply-To: <49152F4E.5040003@shikadi.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2008 07:18 AM, Adam Nielsen wrote:
> Here is the code so far, if it's useful: (I've omitted all the error
> checking code for clarity, all the functions called here return success)
> 
> --------------------------------------------
> static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL, 0);
> 
> static struct attribute *odin_attributes[] = {
>   &sensor_dev_attr_temp1_input.dev_attr.attr,
>   NULL
> };
> 
> static const struct attribute_group odin_attr_group = {
>   .attrs = odin_attributes,
> };
> 
> static int odin_probe(struct hid_device *hdev,
>   const struct hid_device_id *id)
> {
>   hid_parse(hdev);
>   hid_hw_start(hdev, HID_CONNECT_DEFAULT);
> 
>   odin_psu = kzalloc(sizeof(struct odin_psu_device), GFP_KERNEL);
>   odin_psu->hdev = hdev;
> 
>   hid_set_drvdata(hdev, odin_psu);
> 
>   sysfs_create_group(&hdev->dev.kobj, &odin_attr_group);
>   odin_psu->hwmon_dev = hwmon_device_register(&hdev->dev);
> 
>   return 0;
> }
> --------------------------------------------
> If anyone can see why this might result in no sysfs files, please let me
> know!  I previously had most of this code working with a platform_device
> instead of the hid_device, which is what makes me wonder about
> hdev->dev.kobj.  (Not sure how to test if that variable is accurate,
> either.)  Or perhaps it has already been used elsewhere and it can only
> be used once?

I suppose it's under /sys/bus/hid/devices/.../, isn't it?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYKHVvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYKHVvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 16:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYKHVvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 16:51:11 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:31957 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYKHVvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 16:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=d4VR0zXSuyYINMFCqUl3jeN8pAZX/kqIaSaJM/q0+KEbMaPGa8CMxNdGOC2UbjEG7K
         IlZ2m5jW3OCQ+dqeRCBYhsNCFGpyWmCAiL6WL6+aciwJPjwiuyiNEU767fO1pLxqeBJk
         NMH3tdIcgXpHAoWXu6DmOmeFdX9+gGDy0Kn7c=
Message-ID: <491609CA.30303@gmail.com>
Date: Sat, 08 Nov 2008 22:51:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Adam Nielsen <a.nielsen@shikadi.net>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: hid class and sysfs/hwmon
References: <490FFF1B.6050300@shikadi.net> <4910C32F.9060204@gmail.com> <49152F4E.5040003@shikadi.net> <49159F54.8090500@gmail.com> <4916087F.30100@shikadi.net>
In-Reply-To: <4916087F.30100@shikadi.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Nielsen napsal(a):
>>> If anyone can see why this might result in no sysfs files, please let me
>>> know!  I previously had most of this code working with a platform_device
>>> instead of the hid_device, which is what makes me wonder about
>>> hdev->dev.kobj.  (Not sure how to test if that variable is accurate,
>>> either.)  Or perhaps it has already been used elsewhere and it can only
>>> be used once?
>>
>> I suppose it's under /sys/bus/hid/devices/.../, isn't it?
> 
> Aha, yes!  I didn't even think of checking there.  I suppose this means
> I have to create another device (like a platform_device) in order to
> have the sysfs files appear in the correct place?
> 
> Is a platform_device the correct type to create, or is there another way?

I don't know much about hwmon, but I would guess you should use hwmon_dev
for registering the attributes if you want it under /sys/class/hwmon/...

Such as:
sysfs_create_group(&odin_psu->hwmon_dev->kobj, &odin_attr_group);

No?

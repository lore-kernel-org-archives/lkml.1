Return-Path: <linux-kernel-owner+w=401wt.eu-S1945961AbXDEGsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945961AbXDEGsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 02:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945962AbXDEGsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 02:48:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:61678 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945961AbXDEGsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 02:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=BTy5cuVsX0c+Sf8HUPNRWeXb9j+eNPKWRFfwb2tD1BbA7Bi4Er2AIeE14RYu4Gb264ZyjH9oy+c2D44fC+RbC3lxFKbk/Fz+j6yBYcZ/jNTqlNAVxm40TnUydjze36XVgdwKZgvRBeR+G67yE6XwaXPLaIFpm2elNGe93wscN+E=
Message-ID: <46149B77.1030607@gmail.com>
Date: Thu, 05 Apr 2007 14:47:19 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Li Yu <raise.sail@gmail.com>
CC: Dmitry Torokhov <dtor@insightbb.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Jiri Kosina <jkosina@suse.cz>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com>	<Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz>	<46145026.3050305@gmail.com>	<200704042309.19344.dtor@insightbb.com> <4614890E.4030908@gmail.com>
In-Reply-To: <4614890E.4030908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
>>> +int hid_open(struct hid_device *hid)
>>> +{
>>> +	struct hid_transport *tl;
>>> +	int ret;
>>> +
>>> +	if (hid->driver->open)
>>> +		return hid->driver->open(hid);
>>> +	ret = 0;
>>> +	spin_lock(&hid_lock);
>>> +	tl =  hid_transports[hid->bus];
>>> +	if (tl->open)
>>> +		ret = tl->open(hid);
>>> +	spin_unlock(&hid_lock);
>>> +	return ret;
>>> +}
>>>     
>>>       
>> Spinlock is not the best choise here, I'd expect most ->open()
>> implementation wait on some IO.
>>
>>   
>>     
> Yes, I agree! Also, there have another code access hid_transports[]
> without spin it!
>
>   
I think I found out the resolve means for this: using the refcnt of
hid_transport->module,
so we can read access hid_transports[] safely without any lock protection.







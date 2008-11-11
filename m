Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYKKWcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYKKWcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYKKWcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:32:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44032 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbYKKWcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:32:17 -0500
Message-ID: <491A07D4.2020001@redhat.com>
Date: Wed, 12 Nov 2008 00:31:48 +0200
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, avi@redhat.com
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>	<1226409701-14831-2-git-send-email-ieidus@redhat.com>	<1226409701-14831-3-git-send-email-ieidus@redhat.com>	<1226409701-14831-4-git-send-email-ieidus@redhat.com>	<20081111150345.7fff8ff2@bike.lwn.net>	<491A0483.3010504@redhat.com> <20081111152527.3c55bd6d@bike.lwn.net>
In-Reply-To: <20081111152527.3c55bd6d@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> On Wed, 12 Nov 2008 00:17:39 +0200
> Izik Eidus <ieidus@redhat.com> wrote:
>
>   
>>>> +static int ksm_dev_open(struct inode *inode, struct file *filp)
>>>> +{
>>>> +	try_module_get(THIS_MODULE);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int ksm_dev_release(struct inode *inode, struct file *filp)
>>>> +{
>>>> +	module_put(THIS_MODULE);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static struct file_operations ksm_chardev_ops = {
>>>> +	.open           = ksm_dev_open,
>>>> +	.release        = ksm_dev_release,
>>>> +	.unlocked_ioctl = ksm_dev_ioctl,
>>>> +	.compat_ioctl   = ksm_dev_ioctl,
>>>> +};
>>>>       
>>>>         
>>> Why do you roll your own module reference counting?  Is there a
>>> reason you don't just set .owner and let the VFS handle it?
>>>     
>>>       
>> Yes, I am taking get_task_mm() if the module will be removed before i 
>> free the mms, things will go wrong
>>     
>
> But...if you set .owner, the VFS will do the try_module_get() *before*
> calling into your module (as an added bonus, it will actually check the
> return value too).  
Ohhh i see what you mean
you are right i had at least needed to check for the return value of 
try_module_get(),
anyway will check this issue for V2.

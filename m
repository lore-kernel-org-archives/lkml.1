Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab0BUJL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 04:11:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:40436 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab0BUJL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 04:11:27 -0500
Message-ID: <4B80FA08.8080304@windriver.com>
Date: Sun, 21 Feb 2010 17:16:56 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: rusty@rustcorp.com.au, davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jason.wessel@windriver.com, lenb@kernel.org,
       dwmw2@infradead.org, mdharm-usb@one-eyed-alien.net,
       bfields@fieldses.org, robert.richter@amd.com
Subject: Re: [PATCH] module param_call: fix potential NULL pointer dereference
References: <1266737078-26186-1-git-send-email-dongdong.deng@windriver.com> <2375c9f91002210041l1bf30871vdf3881589a654d5a@mail.gmail.com>
In-Reply-To: <2375c9f91002210041l1bf30871vdf3881589a654d5a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Feb 2010 09:10:53.0793 (UTC) FILETIME=[C517CD10:01CAB2D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Sun, Feb 21, 2010 at 3:24 PM, Dongdong Deng
> <dongdong.deng@windriver.com> wrote:
>> The param_set_fn() function will get a parameter which is a NULL
>> pointer when insmod module with params via following method:
>>
>> $insmod module.ko module_params
>>
>> BTW: the normal method usually as following format:
>> $insmod module.ko module_params=example
>>
>> If the param_set_fn() function didn't check that parameter and used
>> it directly, it could caused an OOPS due to NULL pointer dereference.
>>
>> The solution is simple:
>> Just checking the parameter before using in param_set_fn().
>>
>> Example:
>> int set_module_params(const char *val, struct kernel_param *kp)
>> {
>>        /*Checking the val parameter before using */
>>        if (!val)
>>                return -EINVAL;
>>        ...
>> }
>> module_param_call(module_params, set_module_params, NULL, NULL, 0644);
>>
> 
> Why not just checking all of them in the generic code?

It is no problem that we check the params before invoking param_set_fn().

But I trend to do the checking in param_set_*fn(), because we can offer 
some special prompt infos to user if we want and handle some special 
cases like param_set_bool().

Thanks,
Dongdong


> How about my _untested_ patch below?
> 
> Thanks.
> 
> -----------
> 
> When a module parameter "foo" is not bool, 

we shouldn't accept arguments
> like this "insmod ./foo.ko foo". However, currently only standard
> ->set functions
> check this, several non-standard ->set functions ignore this, thus could cause
> NULL def oops.
> 
> Reported-by: Dongdong Deng <dongdong.deng@windriver.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> 


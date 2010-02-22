Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab0BVKFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:05:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:64687 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab0BVKFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:05:47 -0500
Message-ID: <4B825846.1030203@windriver.com>
Date: Mon, 22 Feb 2010 18:11:18 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jason.wessel@windriver.com, lenb@kernel.org,
       dwmw2@infradead.org, mdharm-usb@one-eyed-alien.net,
       bfields@fieldses.org, robert.richter@amd.com
Subject: Re: [PATCH] module param_call: fix potential NULL pointer dereference
References: <1266737078-26186-1-git-send-email-dongdong.deng@windriver.com> <2375c9f91002210041l1bf30871vdf3881589a654d5a@mail.gmail.com> <201002221941.21662.rusty@rustcorp.com.au>
In-Reply-To: <201002221941.21662.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Feb 2010 10:05:11.0353 (UTC) FILETIME=[8529C290:01CAB3A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Sun, 21 Feb 2010 07:11:36 pm Américo Wang wrote:
>> On Sun, Feb 21, 2010 at 3:24 PM, Dongdong Deng
>> <dongdong.deng@windriver.com> wrote:
>>> The param_set_fn() function will get a parameter which is a NULL
>>> pointer when insmod module with params via following method:
>>>
>>> $insmod module.ko module_params
>>>
>>> BTW: the normal method usually as following format:
>>> $insmod module.ko module_params=example
>>>
>>> If the param_set_fn() function didn't check that parameter and used
>>> it directly, it could caused an OOPS due to NULL pointer dereference.
>>>
>>> The solution is simple:
>>> Just checking the parameter before using in param_set_fn().
>>>
>>> Example:
>>> int set_module_params(const char *val, struct kernel_param *kp)
>>> {
>>>        /*Checking the val parameter before using */
>>>        if (!val)
>>>                return -EINVAL;
>>>        ...
>>> }
>>> module_param_call(module_params, set_module_params, NULL, NULL, 0644);
>>>
>> Why not just checking all of them in the generic code?
> 
> It seemed useful to allow 'foo' as well as 'foo='. 

Ah, this is a good method to deal with this issue.

I will redo this patch shortly.

Thanks,
Dongdong

  But given these examples,
> obviously that was too easy to misuse.
> 
> So I like your patch; please annotate it properly and put a comment
> like:
> 	/* We used to hand NULL for bare params, but most code didn't handle it :( */
> 
> I assume none of those non-standard param parsers *want* to handle NULL?
> 
> Thanks,
> Rusty.


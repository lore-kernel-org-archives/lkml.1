Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab0BVHhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 02:37:05 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:15744 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab0BVHhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 02:37:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tKXKfVqt1+iSBHdGk8Cf4MlBvECxC6+D1eqOVF/d2QP9bJWWsrToQT6b5Xvf6nErzi
         7M7jYMZbqrU7Py78OKedqoyOOX9pUawh6EMWFMH8cUFAkQdAhj/117kzrZoked/aCV9Q
         8ezYRTYhWNDN7yyHZPNHqnP8b7IyPHFu5raLs=
MIME-Version: 1.0
In-Reply-To: <4B80FA08.8080304@windriver.com>
References: <1266737078-26186-1-git-send-email-dongdong.deng@windriver.com>
	 <2375c9f91002210041l1bf30871vdf3881589a654d5a@mail.gmail.com>
	 <4B80FA08.8080304@windriver.com>
Date: Mon, 22 Feb 2010 15:37:00 +0800
Message-ID: <2375c9f91002212337l543795d5ndb24173dd19e039e@mail.gmail.com>
Subject: Re: [PATCH] module param_call: fix potential NULL pointer dereference
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: DDD <dongdong.deng@windriver.com>
Cc: rusty@rustcorp.com.au, davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jason.wessel@windriver.com, lenb@kernel.org,
       dwmw2@infradead.org, mdharm-usb@one-eyed-alien.net,
       bfields@fieldses.org, robert.richter@amd.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 5:16 PM, DDD <dongdong.deng@windriver.com> wrote:
> Américo Wang wrote:
>>
>> On Sun, Feb 21, 2010 at 3:24 PM, Dongdong Deng
>> <dongdong.deng@windriver.com> wrote:
>>>
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
>>>       /*Checking the val parameter before using */
>>>       if (!val)
>>>               return -EINVAL;
>>>       ...
>>> }
>>> module_param_call(module_params, set_module_params, NULL, NULL, 0644);
>>>
>>
>> Why not just checking all of them in the generic code?
>
> It is no problem that we check the params before invoking param_set_fn().
>
> But I trend to do the checking in param_set_*fn(), because we can offer some
> special prompt infos to user if we want and handle some special cases like
> param_set_bool().
>

Yeah, I knew standard bool parameters can accept that,
the problem is that KPARAM_ISBOOL is not enough to
check if a parameter is bool or not. Probably we need
a new flag...

Thanks.

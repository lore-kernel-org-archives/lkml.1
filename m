Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0BWEhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 23:37:45 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:22977 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab0BWEho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 23:37:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=u1cDVdgjTGpv18MPPfvvzu2AC5lOre3qKbePMv2j17AjuUWekK1HTwXyO92sfKCu7Q
         BgrgMOAwzKnz+sM/NGr34pvEE6eiHjCZJW3DvFIljvQMNgjS2TDPU7BgIpVnsogbRd6v
         P56qn2bnVaVK0T+h2xflkdPa4K1qkbv4GqMQ0=
MIME-Version: 1.0
In-Reply-To: <201002231426.45886.rusty@rustcorp.com.au>
References: <1266835251-15457-1-git-send-email-dongdong.deng@windriver.com>
	 <201002231426.45886.rusty@rustcorp.com.au>
Date: Tue, 23 Feb 2010 12:37:42 +0800
Message-ID: <2375c9f91002222037v5456251crf8d8128aa9b8a164@mail.gmail.com>
Subject: Re: [RESEND PATCH] module param_call: fix potential NULL pointer 
	dereference
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dongdong Deng <dongdong.deng@windriver.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 11:56 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Mon, 22 Feb 2010 09:10:51 pm Dongdong Deng wrote:
>> The param_set_fn() function will get a parameter which is a NULL
>> pointer when insmod module via bare params as following method:
>>
>> $insmod foo.ko foo
>>
>> If the param_set_fn() function didn't check that parameter and used
>> it directly, it could caused an OOPS due to NULL pointer dereference.
>>
>> The solution is simple:
>> Using "" to replace NULL parameter, thereby the param_set_fn()
>> function will never get a NULL pointer.
>
> This changes the value of booleans, and loses checking for int params, etc.
>
> I liked Americo's approach; I've combined the two approaches below.
>
> Since I'm going away, can Andrew take this?
>
> Subject: params: don't hand NULL values to param.set callbacks.
>
> An audit by Dongdong Deng revealed that most driver-author-written param
> calls don't handle val == NULL (which happens when parameters are specified
> with no =, eg "foo" instead of "foo=1").
>
> The only real case to use this is boolean, so handle it specially for that
> case and remove a source of bugs for everyone else as suggested by Americo.
>

Yeah, thanks, this one looks better than mine.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

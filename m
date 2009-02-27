Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZB0Mft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZB0Mft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 07:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbZB0Mfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 07:35:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:2000 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZB0Mfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 07:35:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cwjylcNzkeLtVC18hfRT7MZNWsdSP3F/ZXNA9Sk6TiC4VDqQ/Gdd67pVrp8dHa1blE
         50u741FmzCX3xoNy46Okj22+uxrXcpRkTNZZ1rVej1OSQH8LZwaKEboTLlCIz1NuNWgI
         VaPo2KSn9O8afkAkwjryW3g0K2CTtnnOBzpS8=
MIME-Version: 1.0
In-Reply-To: <9c9fda240902261811g49483f9fk9ac7945834b8764@mail.gmail.com>
References: <20090225044730.GA9106@july>
	 <5d5443650902252301l19d08e67t54c1cea004442be2@mail.gmail.com>
	 <9c9fda240902261811g49483f9fk9ac7945834b8764@mail.gmail.com>
Date: Fri, 27 Feb 2009 18:05:37 +0530
Message-ID: <5d5443650902270435y38a006datc6767524e7290fb0@mail.gmail.com>
Subject: Re: [PATCH] Input notifier support
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Fri, Feb 27, 2009 at 7:41 AM, Kyungmin Park <kmpark@infradead.org> wrote:
> Hi,
>
> On Thu, Feb 26, 2009 at 4:01 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
>> Hi Kyungmin,
>>
>>> diff --git a/drivers/input/input.c b/drivers/input/input.c
>>> index 1730d73..7e96635 100644
>>> --- a/drivers/input/input.c
>>> +++ b/drivers/input/input.c
>>> @@ -274,6 +274,8 @@ void input_event(struct input_dev *dev,
>>>                add_input_randomness(type, code, value);
>>>                input_handle_event(dev, type, code, value);
>>>                spin_unlock_irqrestore(&dev->event_lock, flags);
>>> +               if (type == EV_KEY)
>>> +                       input_notifier_call_chain(value, &code);
>>
>> This check will be done for every input_report_xxx calls, even for
>> touchscreen events (in which case of course it will fail), and I don't
>> think this is optimal solution. Users should be given an option to
>> disable this if they don't need this notification mechanism.
>>
>> How about moving this to input_report_key?
>
> Good, Thank you for point it. I will move it to input_report_key.

As most of the other platforms may not need input_notify as standard
in-built feature, it is better to add Kconfig symbol for this, so that
it can be compiled out when not needed.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

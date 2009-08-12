Return-Path: <linux-kernel-owner+w=401wt.eu-S1750940AbZHLX7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbZHLX7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbZHLX7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:59:32 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:33169 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZHLX7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w5O7ZIx0RJKYc3EKd0AxykqJ/DPfOxyzvDgO758a0mEjUijD4y1rdIIZK1S0HVXgbu
         BRi/lqdKwMtkx/np9qu1jCoRtjAPIpm4U9U9LEJe8XL40LoFwjTZ2mzeUZ9GfzHvrJbT
         Kx6QwBtsK4hfyVMW+gkZuWfH4HSYpsn4ZqKIA=
Message-ID: <4A835760.2050803@gmail.com>
Date: Wed, 12 Aug 2009 17:59:28 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Flooded by do_IRQ: 0.91 No irq handler for vector
References: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>	 <4A80C2F8.2040208@gmail.com>	 <d12c1890908101825t44138bf4x9a4733ece6f74b88@mail.gmail.com> <d12c1890908111528p47cdd30bw24749e34fc1cc8d3@mail.gmail.com>
In-Reply-To: <d12c1890908111528p47cdd30bw24749e34fc1cc8d3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 04:28 PM, Luis Fernando Planella Gonzalez wrote:
> I'm really concerned that all those interrupts might slow down the
> computer somehow...
> Here is an attached syslog part after a reboot.
> Sometimes, the ratelimit says that thousands of callbacks were suppressed.
> Is there a way to make this message be displayed only once?
>
> In arch/x86/kernel/irq.c, the line 213 is:
> irq = __get_cpu_var(vector_irq)[vector];
>
> In my case, the returned irq is -1. Doesn't it makes sense to not log
> the "No irq handler for vector" message when irq<  0?
>
> Or even a deeper answer: Why, in my case, the resulting irq is -1?

Not logging would just cover up the problem, the issue in your case is 
that something seems to be asserting a ton of interrupts on an IRQ line 
that no driver has claimed..

>
>
>
> 2009/8/10 Luis Fernando Planella Gonzalez<lfpg.dev@gmail.com>:
>> I've just compiled 2.6.30.4, and it shows another info:
>> do_IRQ: 0.91 No irq handler for vector (irq -1)
>>
>> Attached are the /proc/interrupts and the lspci -vv
>>
>> Anyway, sorry for not specifying my hardware:
>> * Intel Core2 Duo 2.13 GHz
>> * 2GB RAM
>> * NVidia 7900 GS
>>
>> Thanks.
>>


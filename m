Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZBTOuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZBTOuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZBTOuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:50:04 -0500
Received: from proxy3.bredband.net ([195.54.101.73]:35884 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZBTOuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:50:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al0MAKtRnknVcsfHPGdsb2JhbAAIlEUBAQEBNQG/XYQPBg
Message-ID: <499EC317.6010506@sundmangroup.com>
Date: Fri, 20 Feb 2009 15:49:59 +0100
From: Matias <linux@sundmangroup.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: zaharov <zaharov@sbmag.ru>, linux-kernel@vger.kernel.org
Subject: Re: SMP Kernel
References: <499EB742.4050208@sundmangroup.com> <499EBAC6.60804@sbmag.ru>
In-Reply-To: <499EBAC6.60804@sbmag.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Ok, since the memory is shared between all the cores the Kernel can be 
invoked by any core receiving an interrupt and thus executed by that core?

If the above is right then how come that two separate CPUs can wake up, 
schedule and context-switch completely in parallel?
Are there an independent scheduler per cpu?

Directly from the sched-design.txt

- 'perfect' SMP scalability. With the new scheduler there is no 'big'
   runqueue_lock anymore - it's all per-CPU runqueues and locks - two
   tasks on two separate CPUs can wake up, schedule and context-switch
   completely in parallel, without any interlocking. All
   scheduling-relevant data is structured for maximum scalability.


Thx // Matias





zaharov skrev:
> Matias wrote:
>   
>> Hello,
>> When an SMP enabled kernel is booted on a Dual Core x86 machine ( Core
>> 0-1 ) I guess the Kernel is decompressed and started on core 0.
>> At some point in time the kernel becomes SMP aware and can then
>> distribute threads on Cores 0 and 1.
>>
>> Now, does the non-threaded part of the kernel with the scheduler
>> continue to run solely on Core 0?
>>
>> Cheers // Matias
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>     
> Kernel may run on any core .
> When kernel end bootstrap and run init he execute hlt op.
> After all live in kernel  interrupt driven.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

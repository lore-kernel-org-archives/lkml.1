Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbYBVWm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbYBVWm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbYBVWl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:41:58 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9335 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530AbYBVWl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:41:56 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5236"; a="775794"
Message-ID: <47BF4FB1.80205@qualcomm.com>
Date: Fri, 22 Feb 2008 14:41:53 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Tejun Heo <htejun@gmail.com>, rusty@rustcorp.com.au,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Module loading/unloading and "The Stop Machine"
References: <47ABC08C.8010101@qualcomm.com> <47B3BD51.1080706@gmail.com>	<47BE245F.3030809@qualcomm.com> <47BE27AE.8050009@gmail.com>	<47BE29A0.6040409@qualcomm.com> <p73prup8awh.fsf@bingen.suse.de>
In-Reply-To: <p73prup8awh.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

> Max Krasnyanskiy <maxk@qualcomm.com> writes:
>> static struct module *load_module(void __user *umod,
>>                                  unsigned long len,
>>                                  const char __user *uargs)
>> {
>>      ...
>>
>>      /* Now sew it into the lists so we can get lockdep and oops
>>         * info during argument parsing.  Noone should access us, since
>>         * strong_try_module_get() will fail. */
>>        stop_machine_run(__link_module, mod, NR_CPUS);
>>      ...
>> }
> 
> Wow you found some really bad code. I bet it wouldn't be that
> difficult to fix the code to allow oops safe list insertion
> without using the big stop machine overkill hammer.
Let me know if you have something in mind. When I get a chance I'll stare
some more at that code and try to come up with an alternative solution.

Thanx
Max

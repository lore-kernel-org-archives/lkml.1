Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYJCHpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYJCHpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 03:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYJCHov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 03:44:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34857 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbYJCHou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 03:44:50 -0400
Message-ID: <48E5CD56.5060202@zytor.com>
Date: Fri, 03 Oct 2008 00:44:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com> <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com> <20081003003237.04469201@werewolf.home> <20081003073727.GC4950@elte.hu> <48E5CBFC.3090702@zytor.com> <20081003074246.GE4950@elte.hu>
In-Reply-To: <20081003074246.GE4950@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>>
>>>> +++ arch/x86/kernel/cpu/mtrr/if.c     2008-10-03 00:22:34.000000000 +0200
>>>> @@ -16,7 +16,7 @@
>>>>  static const char *const mtrr_strings[MTRR_NUM_TYPES] =
>>>>  {
>>>>      "uncachable",               /* 0 */
>>>> -    "write-combining",          /* 1 */
>>>> +    "write-combine",            /* 1 */
>>> hm, maybe this bit could confuse versions of Xorg that modifies  
>>> /proc/mtrr - i.e. this could be part of the ABI towards user-space.  
>>> We'll see.
>>>
>> This *IS* part of the ABI toward userspace, although I think Xorg uses 
>> the ioctl() interface.
> 
> yeah, but aspects of the ABI that applications do not rely on can 
> generally be changed. OTOH, i've undone this aspect of the patch - 
> /proc/mtrr is a legacy interface and changes to it are unnecessary. I 
> kept the boot printout cleanups.
> 

Great.  It's worth noting that these strings aren't just used for 
readout, but also for setting.

	-hpa

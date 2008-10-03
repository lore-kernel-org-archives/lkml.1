Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYJCHjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYJCHjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 03:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbYJCHjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 03:39:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44696 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbYJCHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 03:39:03 -0400
Message-ID: <48E5CBFC.3090702@zytor.com>
Date: Fri, 03 Oct 2008 00:38:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com> <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com> <20081003003237.04469201@werewolf.home> <20081003073727.GC4950@elte.hu>
In-Reply-To: <20081003073727.GC4950@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * J.A. Magallón <jamagallon@ono.com> wrote:
> 
>> Also, on a 64 bit box with 4Gb, it gives this:
>>
>> cicely:~# cat /proc/mtrr
>> reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>> reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>> reg02: base=0x140000000 (5120MB), size= 512MB: write-back, count=1
>> reg03: base=0x160000000 (5632MB), size= 256MB: write-back, count=1
>> reg04: base=0x80000000 (2048MB), size=2048MB: uncachable, count=1
>>
>> Patch below cleans up formatting, with space for big bases and sizes (64 Gb).
> 
> applied to tip/x86/mtrr, thanks!
> 
>> +++ arch/x86/kernel/cpu/mtrr/if.c     2008-10-03 00:22:34.000000000 +0200
>> @@ -16,7 +16,7 @@
>>  static const char *const mtrr_strings[MTRR_NUM_TYPES] =
>>  {
>>      "uncachable",               /* 0 */
>> -    "write-combining",          /* 1 */
>> +    "write-combine",            /* 1 */
> 
> hm, maybe this bit could confuse versions of Xorg that modifies 
> /proc/mtrr - i.e. this could be part of the ABI towards user-space. 
> We'll see.
> 

This *IS* part of the ABI toward userspace, although I think Xorg uses 
the ioctl() interface.

	-hpa

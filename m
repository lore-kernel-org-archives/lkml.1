Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYJCHnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYJCHnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 03:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYJCHmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 03:42:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50382 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbYJCHmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 03:42:55 -0400
Date: Fri, 3 Oct 2008 09:42:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: =?iso-8859-1?B?IkouQS4gTWFnYWxs824i?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Message-ID: <20081003074246.GE4950@elte.hu>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com> <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com> <20081003003237.04469201@werewolf.home> <20081003073727.GC4950@elte.hu> <48E5CBFC.3090702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48E5CBFC.3090702@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
>> * J.A. Magallón <jamagallon@ono.com> wrote:
>>
>>> Also, on a 64 bit box with 4Gb, it gives this:
>>>
>>> cicely:~# cat /proc/mtrr
>>> reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>>> reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>>> reg02: base=0x140000000 (5120MB), size= 512MB: write-back, count=1
>>> reg03: base=0x160000000 (5632MB), size= 256MB: write-back, count=1
>>> reg04: base=0x80000000 (2048MB), size=2048MB: uncachable, count=1
>>>
>>> Patch below cleans up formatting, with space for big bases and sizes (64 Gb).
>>
>> applied to tip/x86/mtrr, thanks!
>>
>>> +++ arch/x86/kernel/cpu/mtrr/if.c     2008-10-03 00:22:34.000000000 +0200
>>> @@ -16,7 +16,7 @@
>>>  static const char *const mtrr_strings[MTRR_NUM_TYPES] =
>>>  {
>>>      "uncachable",               /* 0 */
>>> -    "write-combining",          /* 1 */
>>> +    "write-combine",            /* 1 */
>>
>> hm, maybe this bit could confuse versions of Xorg that modifies  
>> /proc/mtrr - i.e. this could be part of the ABI towards user-space.  
>> We'll see.
>>
>
> This *IS* part of the ABI toward userspace, although I think Xorg uses 
> the ioctl() interface.

yeah, but aspects of the ABI that applications do not rely on can 
generally be changed. OTOH, i've undone this aspect of the patch - 
/proc/mtrr is a legacy interface and changes to it are unnecessary. I 
kept the boot printout cleanups.

	Ingo

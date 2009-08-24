Return-Path: <linux-kernel-owner+w=401wt.eu-S1751139AbZHXBVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbZHXBVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbZHXBVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:21:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49735 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZHXBVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:21:41 -0400
Message-ID: <4A91EB08.6030009@cn.fujitsu.com>
Date: Mon, 24 Aug 2009 09:21:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86: fix system die when load with "reservetop"	parameter
References: <4A8D402F.4080805@cn.fujitsu.com> <20090821133553.GE10263@elte.hu>
In-Reply-To: <20090821133553.GE10263@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
>> The system will die if the kernel is booted with "reservetop" 
>> parameter, in present code, parse "reservetop" parameter after 
>> early_ioremap_init(), and some function still use early_ioremap() 
>> after it.
> 
> btw., what are you using the 'reservetop' boot option for?
> 

Hi Ingo,

Actually, this bug is detected by my review first, then confirm it by
loading with "reservetop" parameter

>> The problem is, "reservetop" parameter can modify 'FIXADDR_TOP', 
>> then the virtual address got by early_ioremap() is base on old 
>> 'FIXADDR_TOP', but the page mapping is base on new 'FIXADDR_TOP', 
>> it will occur page fault, and the IDT is not prepare yet, so, the 
>> system is dead.
>>
>> So, put parse_early_param() in the front of early_ioremap_init() 
>> in this patch.
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  arch/x86/kernel/setup.c |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> Does this bug trigger in 2.6.30 too?
> 
> I'm quite nervous about doing this change so late in the .31 cycle, 
> we've got a hundred early parameters that now get executed much 
> earlier than before. No way can i test all of them and others 
> testing it (like in your case) takes time to trickle through.
> 
> So unless this is a .31 regression i'd be inclined to queue it up 
> for .32.
> 

OK, this parameter is introduced in v2.6.27, but It seems like less
people use it and no one report this bug before. So, I think we can
queue it up for .32

Thanks,
Xiao

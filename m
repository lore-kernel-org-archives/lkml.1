Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYKQSDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYKQSDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYKQSDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:03:06 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:59366 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYKQSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:03:03 -0500
Message-ID: <4921B1D7.5060608@ct.jp.nec.com>
Date: Mon, 17 Nov 2008 10:03:03 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86: ia32_signal: introduce COPY_SEG_STRICT
References: <491E4101.7010405@ct.jp.nec.com> <491E416F.5040703@ct.jp.nec.com> <2375c9f90811150911l3cfba998r1ae949912b7a8df3@mail.gmail.com>
In-Reply-To: <2375c9f90811150911l3cfba998r1ae949912b7a8df3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Sat, Nov 15, 2008 at 3:26 AM, Hiroshi Shimamoto
> <h-shimamoto@ct.jp.nec.com> wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Impact: cleanup
>>
>> Introduce COPY_SEG_STRICT for ia32_restore_sigcontext().
>>
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> ---
>>  arch/x86/ia32/ia32_signal.c |   12 ++++++++----
>>  1 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
>> index a28790a..f74178e 100644
>> --- a/arch/x86/ia32/ia32_signal.c
>> +++ b/arch/x86/ia32/ia32_signal.c
>> @@ -201,6 +201,12 @@ struct rt_sigframe
>>        err |= __get_user(regs->x, &sc->x);     \
>>  }
>>
>> +#define COPY_SEG_STRICT(seg)   {                       \
>> +               unsigned short tmp;                     \
>> +               err |= __get_user(tmp, &sc->seg);       \
>> +               regs->seg = tmp | 3;                    \
>> +}
>> +
> 
> Since your first patch is to kill the temporary variables, then why do you
> introduce a temporary variable here? It can be avoided like it was.
> 
> Can you explain the reason? :)

The first reason is to make this macro same as arch/x86/kernel/signal_{32|64}.c.
And second, I guess gcc may generate little better code.

thanks,
Hiroshi Shimamoto

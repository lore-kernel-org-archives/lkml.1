Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYKQSUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYKQSUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYKQSUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:20:34 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:7248 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYKQSUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:20:33 -0500
Message-ID: <4921B5F0.6050105@ct.jp.nec.com>
Date: Mon, 17 Nov 2008 10:20:32 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: ia32_signal: change order of storing in setup_sigcontext()
References: <491E4101.7010405@ct.jp.nec.com> <491E41F2.4030403@ct.jp.nec.com> <2375c9f90811150925l2aebbdfejed8725f15a801e1d@mail.gmail.com>
In-Reply-To: <2375c9f90811150925l2aebbdfejed8725f15a801e1d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Sat, Nov 15, 2008 at 3:28 AM, Hiroshi Shimamoto
> <h-shimamoto@ct.jp.nec.com> wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Impact: cleanup
>>
>> Change order of storing to match the sigcontext_ia32.
> 
> 
> Well, more than reordering... Please see below.
> 
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> ---
>>  arch/x86/ia32/ia32_signal.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
>> index 2883f41..909181a 100644
>> --- a/arch/x86/ia32/ia32_signal.c
>> +++ b/arch/x86/ia32/ia32_signal.c
>> @@ -360,13 +360,13 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
>>        err |= __put_user(regs->dx, &sc->dx);
>>        err |= __put_user(regs->cx, &sc->cx);
>>        err |= __put_user(regs->ax, &sc->ax);
>> -       err |= __put_user(regs->cs, &sc->cs);
>> -       err |= __put_user(regs->ss, &sc->ss);
>>        err |= __put_user(current->thread.trap_no, &sc->trapno);
>>        err |= __put_user(current->thread.error_code, &sc->err);
>>        err |= __put_user(regs->ip, &sc->ip);
>> +       err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
>>        err |= __put_user(regs->flags, &sc->flags);
>>        err |= __put_user(regs->sp, &sc->sp_at_signal);
>> +       err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
> 
> 
> Why do you add two casts? If these two are necessary, I am afraid the rest ones
> also need. :)

Thanks, I forgot to mention it.
This cast is to make this code same as arch/x86/kernel/signal_32.c.
No one cares upper part, but it makes improvement by avoiding operand
size prefix.

thanks,
Hiroshi Shimamoto

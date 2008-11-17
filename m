Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYKQR5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYKQR5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYKQR50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:57:26 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:56088 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYKQR5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:57:25 -0500
Message-ID: <4921B084.4070100@ct.jp.nec.com>
Date: Mon, 17 Nov 2008 09:57:24 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: ia32_signal: cleanup macro COPY
References: <491E4101.7010405@ct.jp.nec.com> <2375c9f90811150906r6b2437e9w7c363c40897a862a@mail.gmail.com>
In-Reply-To: <2375c9f90811150906r6b2437e9w7c363c40897a862a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Sat, Nov 15, 2008 at 3:24 AM, Hiroshi Shimamoto
> <h-shimamoto@ct.jp.nec.com> wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Impact: cleanup
>>
>> No need to use temporary variable in this case.
>>
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> ---
>>  arch/x86/ia32/ia32_signal.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
>> index e886907..a28790a 100644
>> --- a/arch/x86/ia32/ia32_signal.c
>> +++ b/arch/x86/ia32/ia32_signal.c
>> @@ -197,10 +197,8 @@ struct rt_sigframe
>>        /* fp state follows here */
>>  };
>>
>> -#define COPY(x)                {               \
>> -       unsigned int reg;               \
>> -       err |= __get_user(reg, &sc->x); \
>> -       regs->x = reg;                  \
>> +#define COPY(x)                        {               \
>> +       err |= __get_user(regs->x, &sc->x);     \
>>  }

Thanks for reviewing this!

> 
> Then you can also kill the braces now. :)

I guess, checkpatch will complain. Personally I don't care.

> 
> What's more, if I saw it correctly, the belowing two __get_user() calls can
> also be replaced by COPY().

I'm sorry, I cannot catch about this. Which __get_user()?

thanks,
Hiroshi Shimamoto

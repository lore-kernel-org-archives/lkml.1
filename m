Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZIRPIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZIRPIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbZIRPIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:08:52 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:16679 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZIRPIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:08:51 -0400
MIME-Version: 1.0
In-Reply-To: <4AB39EC3.4050202@nokia.com>
References: <f00f1348d91d2403ea0f1c5f05b3ac713664fe7b.1253281256.git.kirill@shutemov.name>
	 <alpine.DEB.1.00.0909181422370.11448@ak-desktop>
	 <cc557aab0909180445o33b6792ewf62a4f5e7589547@mail.gmail.com>
	 <4AB39EC3.4050202@nokia.com>
Date: Fri, 18 Sep 2009 18:08:55 +0300
Message-ID: <cc557aab0909180808p675c182eke41b23019a609b9a@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: Aaro Koskinen <aakoskin@nokia.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Russell King <linux@arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 5:52 PM, Aaro Koskinen <aaro.koskinen@nokia.com> wrote:
> Hello,
>
> Kirill A. Shutemov wrote:
>>>
>>>  #ifdef CONFIG_CPU_PABRT_NOIFAR
>>> -# ifdef CPU_PABORT_HANDLER
>>> +# ifdef CPU_PABORT_HANDLER_IFAR
>>>  #  define MULTI_PABORT 1
>>>  # else
>>> -#  define CPU_PABORT_HANDLER(reg, insn)        mov reg, insn
>>> +#  define CPU_PABORT_HANDLER_IFAR(reg, insn)   mov reg, insn
>>> +#  define CPU_PABORT_HANDLER_IFSR(reg)         mrc p15, 0, reg, cr5,
>>> cr0, 1
>>
>> It's incorrect. We have IFSR only on ARMv7.
>
> It seems my assumption on the availability of that register was wrong, but I
> think it's available at least on ARMv6, and also that IFAR can be
> optional...

I can't find anything in ARMv6-M Architecture Reference Manual by
keywords "ifar" or "ifsr".

>
> A.
>

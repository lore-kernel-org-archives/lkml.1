Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZIROxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZIROxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZIROxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:53:09 -0400
Received: from smtp.nokia.com ([192.100.122.233]:20193 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZIROxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:53:08 -0400
Message-ID: <4AB39EC3.4050202@nokia.com>
Date: Fri, 18 Sep 2009 17:52:51 +0300
From: Aaro Koskinen <aaro.koskinen@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "ext Kirill A. Shutemov" <kirill@shutemov.name>
CC: Aaro Koskinen <aakoskin@nokia.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Russell King <linux@arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
References: <f00f1348d91d2403ea0f1c5f05b3ac713664fe7b.1253281256.git.kirill@shutemov.name>	 <alpine.DEB.1.00.0909181422370.11448@ak-desktop> <cc557aab0909180445o33b6792ewf62a4f5e7589547@mail.gmail.com>
In-Reply-To: <cc557aab0909180445o33b6792ewf62a4f5e7589547@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2009 14:52:54.0662 (UTC) FILETIME=[B40AEA60:01CA386F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Kirill A. Shutemov wrote:
>>  #ifdef CONFIG_CPU_PABRT_NOIFAR
>> -# ifdef CPU_PABORT_HANDLER
>> +# ifdef CPU_PABORT_HANDLER_IFAR
>>  #  define MULTI_PABORT 1
>>  # else
>> -#  define CPU_PABORT_HANDLER(reg, insn)        mov reg, insn
>> +#  define CPU_PABORT_HANDLER_IFAR(reg, insn)   mov reg, insn
>> +#  define CPU_PABORT_HANDLER_IFSR(reg)         mrc p15, 0, reg, cr5, cr0, 1
> 
> It's incorrect. We have IFSR only on ARMv7.

It seems my assumption on the availability of that register was wrong, 
but I think it's available at least on ARMv6, and also that IFAR can be 
optional...

A.

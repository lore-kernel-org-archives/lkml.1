Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab0CASRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:17:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54433 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0CASRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:17:04 -0500
Message-ID: <4B8C047A.9030406@zytor.com>
Date: Mon, 01 Mar 2010 10:16:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Wu Fengguang <fengguang.wu@intel.com>, Xiaotian Feng <xtfeng@gmail.com>,
       Sachin Sant <sachinp@in.ibm.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: 2.6.33-git6 boot failure[x86_64] (WARN: at arch/x86/mm/ioremap.c:111)
References: <4B8B43E9.1010506@in.ibm.com> <7b6bb4a51002282218u22c8f4c4wb2a345fcb7a82257@mail.gmail.com> <4B8B7AC7.1070201@in.ibm.com> <7b6bb4a51003010038l49c90414lff1ecaa37c96ad61@mail.gmail.com> <alpine.LFD.2.00.1003011058470.4245@localhost.localdomain> <20100301135551.GA9998@localhost> <alpine.LFD.2.00.1003011728450.4245@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003011728450.4245@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 08:31 AM, Thomas Gleixner wrote:
> On Mon, 1 Mar 2010, Wu Fengguang wrote:
>  Ah walk_system_ram_range() is actually doing almost the same alignment
>> check as the removed x86 page_is_ram(), except that it calls func()
>> with len=0.  This happens when page_is_ram(cffa3000) is called.
>>
>> walk_system_ram_range():
>>     pfn = (unsigned long)(res.start >> PAGE_SHIFT);
>>     len = (unsigned long)((res.end + 1 - res.start) >> PAGE_SHIFT);
>>     ret = (*func)(pfn, len, arg);
>>
>> The following patch should fix the problem.
> 
> Right, that should fix it. Though I wonder whether we should warn
> prominently about non page aligned e820 mapping entries.
> 

Pointless.  It's way too common, and in the case of the lowmem region,
probably correct.

	-hpa

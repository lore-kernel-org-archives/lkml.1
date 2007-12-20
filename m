Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbXLTSgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbXLTSgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXLTSgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:36:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbXLTSgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:36:11 -0500
Message-ID: <476AB525.2050407@zytor.com>
Date: Thu, 20 Dec 2007 10:32:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
References: <20071219183443.GA547@linux-os.sc.intel.com>	<20071219193255.GA2158@elte.hu>	<476972A0.3050105@zytor.com>	<20071219194032.GA8849@elte.hu>	<4769757E.306@zytor.com>	<20071219235357.53157cea@laptopd505.fenrus.org>	<476A9576.3020203@zytor.com> <20071220102202.64f395a7@laptopd505.fenrus.org>
In-Reply-To: <20071220102202.64f395a7@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 20 Dec 2007 08:16:54 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> Arjan van de Ven wrote:
>>> On Wed, 19 Dec 2007 11:48:14 -0800
>>> "H. Peter Anvin" <hpa@zytor.com> wrote:
>>>
>>>> I think C3 guarantees that the cache contents stay intact, and thus
>>>> it might make sense in some technology to preserve the TLB as well
>>>> (being a kind of cache.)
>>> that sounds nice. It's fiction though ;-)
>>>
>>> The thing to realize is that linux only sees "ACPI C3"; the BIOS
>>> maps that C3 to.. well any of the C states the processor in the
>>> system has. What you're saying is afaik correct for the *hardware*
>>> C3, not for the "C3" that Linux sees..
>>>
>> Well, it can only map ACPI C3 to a state which is no more "dead" than 
>> what would normally be permitted by C3.  IIRC, C3 is allowed to
>> require that DMA be turned off (unlike C2), but is not allowed to
>> lose the CPU state.
> 
> state isn't lost if the tlb or the caches are flushed... 
> (properly, eg all pending writebacks are written back first etc)
> 

Oh, right.  My bad.

Of course C3 doesn't guarantee cache retention, only cache coherency.

	-hpa

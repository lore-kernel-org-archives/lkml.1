Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYDWJJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYDWJJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYDWJI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:08:58 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:50031 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYDWJI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:08:56 -0400
Message-ID: <480EF9DE.6000702@aitel.hist.no>
Date: Wed, 23 Apr 2008 10:57:02 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: "Alexander E. Patrakov" <patrakov@gmail.com>
CC: Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Eric Sandeen <sandeen@sandeen.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <20080420120250.4f496861@the-village.bc.nu> <20080420115455.GJ1595@cs181133002.pp.htv.fi> <20080420123731.7282bb16@the-village.bc.nu> <20080420121803.GK1595@cs181133002.pp.htv.fi> <480B4DB4.8070107@sandeen.net> <20080420084127.2fc324ec@laptopd505.fenrus.org> <20080420160327.GE1899@cs181133002.pp.htv.fi> <480C0A39.7080501@gmail.com>
In-Reply-To: <480C0A39.7080501@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander E. Patrakov wrote:
> Adrian Bunk wrote:
>> On Sun, Apr 20, 2008 at 08:41:27AM -0700, Arjan van de Ven wrote:
>>> ...
>>> yes. Adrian is waay off in the weeds on this one. Nobody but him is 
>>> suggesting to remove
>>> 8Kb stacks. I think everyone else agrees that having both options is 
>>> valuable; and there
>>> are better ways to find+fix stack bloat than removing this config 
>>> option.
>>
>> I'm not arguing for removing the option immediately, but long-term we 
>> shouldn't need it.
>>
>> This comes from my experience of removing obsolete drivers for 
>> hardware for which also a more recent driver exists:
>> As long as there is some workaround (e.g. using an older driver or
>> 8k stacks) the workaround will be used instead of the getting proper 
>> bug reports and fixes.
>>
>> As far as I know all problems that are known with 4k stacks are some 
>> nested things with XFS in the trace.
>
> This "as far as I know" is a problem itself. Is it possible to 
> implement (e.g., using some form of memory protection in hardware, but 
> I am not an expert here) an option with 8k stacks that, however, spams 
> the log if the actual usage goes above 4k, and have this as a default 
> for some time? If 4k stacks are the goal that is almost achieved, then 
> this debugging option should have zero impact on performance.
Shouldn't be hard. Use the 8k stack, and have the system mark the second 
page as "not present"
If it ever gets used you get a page fault. The page fault handler then 
have to mark the page
present before returning, as well as queue up some spam (the call chain 
perhaps) for the log.

A less intrusive way is to use 8k stacks as-is, but put a signature in 
the second page.
When the process quits, examine the second stack page to see if the 
signature
got overwritten. This approach will only show that a problem exists, it 
won't
pinpoint exactly what does it.

Helge Hafting


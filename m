Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbYERR7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbYERR7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 13:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYERR7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 13:59:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36609 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbYERR7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 13:59:45 -0400
Message-ID: <48306E8D.5050109@firstfloor.org>
Date: Sun, 18 May 2008 19:59:41 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #10710] [BISECTED] Lots of "rescheduling IPIs" in powertop
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>	 <7wuznNhcUqC.A.xiH.EsBMIB@albercik> <19f34abd0805180523o12732812k87b8ddd832843af4@mail.gmail.com>
In-Reply-To: <19f34abd0805180523o12732812k87b8ddd832843af4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Sun, May 18, 2008 at 1:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.25.  Please verify if it still should be listed.
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10710
>> Subject         : [BISECTED] Lots of "rescheduling IPIs" in powertop
>> Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
>> Date            : 2008-05-13 20:42 (6 days old)
>> References      : http://marc.info/?l=linux-kernel&amp;m=121071176205864&amp;w=4
>> Handled-By      : Andi Kleen <andi@firstfloor.org>
>>                  Arjan van de Ven <arjan@infradead.org>
>>                  Ingo Molnar <mingo@elte.hu>
>> Patch           : http://marc.info/?l=linux-kernel&amp;m=121074826823352&amp;w=4
>>
> 
> Ingo Molnar provided the patch that solved the problem (the referenced
> link) but he wanted to wait for Andreas Herrmann to provide an
> additional patch that would solve some implication on AMD CPUs. So
> this is in theory fixed, but the fix has not yet been applied anywhere
> as far as I know.

There's a CPUID way to distingush the cases I found out now (with help
from Venki, thanks) so it would be possible to solve it properly, but
once even a bad Ingo patch is in it's nearly impossible to replace it
with something better so I bail out at this point.

[In case someone is interested it's CPUID 5 ECX bit 0 which enumerates
if the MWAIT enumeration is there. So the correct mwait_usable() that
would have avoided your problem would be something like (untested):

return c->cpuid_level >= 5 &&
           ((cpuid_ecx(5) & 1) == 0 || (cpuid_edx(5) >> 4) & 0xf) > 0);
]

-Andi

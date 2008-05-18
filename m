Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbYERUam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbYERUam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 16:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYERUaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 16:30:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56311 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYERUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 16:30:34 -0400
Message-ID: <483091E6.9080703@firstfloor.org>
Date: Sun, 18 May 2008 22:30:30 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Vegard Nossum <vegard.nossum@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #10710] [BISECTED] Lots of "rescheduling IPIs" in powertop
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>  <7wuznNhcUqC.A.xiH.EsBMIB@albercik> <19f34abd0805180523o12732812k87b8ddd832843af4@mail.gmail.com> <48306E8D.5050109@firstfloor.org> <alpine.LFD.1.10.0805182017070.18798@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805182017070.18798@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> stop these pointless ad hominem attacks!

Just my experience from past incidents sorry. I'm sure it never happened
to you.

>> [In case someone is interested it's CPUID 5 ECX bit 0 which enumerates
>> if the MWAIT enumeration is there. So the correct mwait_usable() that
>> would have avoided your problem would be something like (untested):
>>
>> return c->cpuid_level >= 5 &&
>>            ((cpuid_ecx(5) & 1) == 0 || (cpuid_edx(5) >> 4) & 0xf) > 0);
>> ]
> 
> I'm interested, but I'd be even more interested in some useful pointer
> to the magic bitnumbers in that check, but don't exert yourself in
> providing the information,

It's documented in the IA32 SDM vol2 as part of the CPUID description.
It's a reasonable expection that everyone hacking on cpuid code has that
at hand.

-Andi

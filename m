Return-Path: <linux-kernel-owner+w=401wt.eu-S1765704AbXJ0AN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765704AbXJ0AN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 20:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbXJ0ANs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 20:13:48 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:20510 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbXJ0ANr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 20:13:47 -0400
Message-ID: <472282B9.4090209@ct.jp.nec.com>
Date: Fri, 26 Oct 2007 17:13:45 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: vgoyal@in.ibm.com, hbabu@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 0/3] x86: unify crash_32/64.c
References: <47195763.1090803@ct.jp.nec.com> <20071024063434.GC4622@in.ibm.com> <471F72AD.8030902@ct.jp.nec.com> <4720D933.3080703@ct.jp.nec.com> <47225F6C.5000708@ct.jp.nec.com> <alpine.LFD.0.9999.0710270035110.3186@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710270035110.3186@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 26 Oct 2007, Hiroshi Shimamoto wrote:
> 
> Added Venki to CC
> 
>>> I'm now testing crash on 32bit, but there is an issue before
>>> applying the patches. My machine stopped at checking 'hlt'
>>> after kexec, showing below message.
>>>
>>> CPU: Intel(R) Xeon(TM) CPU 3.80GHz stepping 0a
>>> Checking 'hlt' instruction...
>>>
>> v2.6.23.1 works fine for 1st kernel.
>>> I'm investigating it..
>> I found that the following patch makes my machine stopped.
>> bfe0c1cc6456bba1f4e3cc1fe29c0ea578ac763a
>> x86: HPET force enable for ICH5
>>
>> It means that after applied this patch, HPET is enabled
>> automatically on 1st kernel and after crash/kexec the 2nd
>> kernel stopped at checking 'hlt'.
>>
>> I also tested the latest kernel(2.6.24-rc1-gec3b67c1).
>> Boot parameter "nohpet" resolves this issue and kdump
>> works well on 32bit.
>> So I guess HPET affects this.
>> But I don't know why 64bit kernel with HPET is OK.
> 
> Hmm. Does the 64 bit code shutdown HPET and restore the IRQ routing to
> PIT and 32 bit is missing this ?

Sorry, I'm not sure how I can get these informations.
Can you please tell me what I should do?
I'll continue to dig the issue.

I also have the following message.
..MP-BIOS bug: 8254 timer not connected to IO-APIC
Kernel panic - not syncing: IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter

It appeared only on 64bit and the 2nd kernel without
boot parameter noapic.


Thanks
Hiroshi Shimamoto

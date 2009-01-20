Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbZATNFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbZATNFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZATNFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:05:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36516 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbZATNFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:05:39 -0500
Message-ID: <4975CBF8.90101@redhat.com>
Date: Tue, 20 Jan 2009 15:04:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kevin Shanahan <kmshanah@ucwb.org.au>
CC: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kevin Shanahan <kmshanah@flexo.wumi.org.au>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>	 <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>	 <1232410363.4768.21.camel@kulgan.wumi.org.au>	 <20090120113546.GA26571@elte.hu> <1232455343.4895.4.camel@kulgan.wumi.org.au>
In-Reply-To: <1232455343.4895.4.camel@kulgan.wumi.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Shanahan wrote:
> On Tue, 2009-01-20 at 12:35 +0100, Ingo Molnar wrote:
>   
>> * Kevin Shanahan <kmshanah@ucwb.org.au> wrote:
>>
>>     
>>> On Mon, 2009-01-19 at 22:45 +0100, Rafael J. Wysocki wrote:
>>>       
>>>> This message has been generated automatically as a part of a report
>>>> of regressions introduced between 2.6.27 and 2.6.28.
>>>>
>>>> The following bug entry is on the current list of known regressions
>>>> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
>>>> be listed and let me know (either way).
>>>>
>>>>
>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
>>>> Subject		: KVM guests stalling on 2.6.28 (bisected)
>>>> Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
>>>> Date		: 2009-01-17 03:37 (3 days old)
>>>>         
>>> Yes, please keep this on the list.
>>>       
>> This only seems to occur under KVM, right? I.e. you tested it with -no-kvm 
>> and the problem went away, correct?
>>     
>
> Well, the I couldn't make the test conditions identical, but it the
> problem didn't occur with the test I was able to do:
>
>   http://marc.info/?l=linux-kernel&m=123228728416498&w=2
>
>   

Can you also try with -no-kvm-irqchip?

You will need to comment out the lines

    /* ISA IRQs map to GSI 1-1 except for IRQ0 which maps
     * to GSI 2.  GSI maps to ioapic 1-1.  This is not
     * the cleanest way of doing it but it should work. */

    if (vector == 0)
        vector = 2;

in qemu/hw/apic.c (should also fix -no-kvm smp).  This will change kvm 
wakeups to use signals rather than the in-kernel code, which may be buggy.

-- 
error compiling committee.c: too many arguments to function


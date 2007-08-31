Return-Path: <linux-kernel-owner+w=401wt.eu-S1761855AbXHaQgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761855AbXHaQgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbXHaQgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:36:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbXHaQgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:36:14 -0400
Message-ID: <46D8437B.3010705@redhat.com>
Date: Fri, 31 Aug 2007 11:36:11 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] detect & print stack overruns at oops time
References: <46D7A71A.7050800@redhat.com> <20070831093253.98f4b640.randy.dunlap@oracle.com>
In-Reply-To: <20070831093253.98f4b640.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Fri, 31 Aug 2007 00:28:58 -0500 Eric Sandeen wrote:
> 
>> Index: linux-2.6.22-rc4/arch/i386/mm/fault.c
>> ===================================================================
>> --- linux-2.6.22-rc4.orig/arch/i386/mm/fault.c
>> +++ linux-2.6.22-rc4/arch/i386/mm/fault.c
>> @@ -543,6 +545,27 @@ no_context:
>>  			printk(KERN_ALERT "BUG: unable to handle kernel paging"
>>  					" request");
>>  		printk(" at virtual address %08lx\n",address);
>> +
>> +		overrun = (unsigned long)stackend - (unsigned long)(&regs->esp);
>> +		if (overrun > 0) {
>> +			printk(KERN_ALERT "Thread overrunning stack by %d "
>> +							"bytes\n", overrun);
>> +		} else {
> 
> Hi,
> 
> Is there something that tells us what <Thread> is doing all of this
> bad juju?

Sure, the rest of the oops report will.

-Eric

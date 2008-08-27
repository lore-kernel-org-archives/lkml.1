Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbYH0Ogn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbYH0Ogn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYH0Ogd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:36:33 -0400
Received: from relay2.sgi.com ([192.48.171.30]:34965 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753377AbYH0Ogc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:36:32 -0400
Message-ID: <48B5666E.2020509@sgi.com>
Date: Wed, 27 Aug 2008 07:36:30 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: nickpiggin@yahoo.com.au, davej@redhat.com, torvalds@linux-foundation.org,
       Alan.Brunelle@hp.com, mingo@elte.hu, tglx@linutronix.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, tony.luck@intel.com, steiner@sgi.com,
       cl@linux-foundation.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <20080826192848.GA20653@redhat.com>	<48B460FE.2020100@sgi.com>	<200808271654.32721.nickpiggin@yahoo.com.au> <20080827.000506.177643294.davem@davemloft.net>
In-Reply-To: <20080827.000506.177643294.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Nick Piggin <nickpiggin@yahoo.com.au>
> Date: Wed, 27 Aug 2008 16:54:32 +1000
> 
>> 5% is a pretty nasty performance hit... what sort of benchmarks are we
>> talking about here?
>>
>> I just made some pretty crazy changes to the VM to get "only" around 5
>> or so % performance improvement in some workloads.
>>
>> What places are making heavy use of cpumasks that causes such a slowdown?
>> Hopefully callers can mostly be improved so they don't need to use cpumasks
>> for common cases.
> 
> It's almost certainly from the cross-call dispatch call chain.
> 
> As just one example, just to do a TLB flush mm->cpu_vm_mask probably
> gets passed around as an aggregate two or three times on the way down
> to the APIC programming code on x86.  That's two or three 512 byte
> copies on the stack :)
> 
> Look at the sparc64 SMP code for how I solved the problem there.

I will, thanks!

Mike

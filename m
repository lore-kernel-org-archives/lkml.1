Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbZHQLY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbZHQLY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbZHQLY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:24:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622AbZHQLYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:24:55 -0400
Date: Mon, 17 Aug 2009 13:24:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:x86/mce3] x86, mce: use 64bit machine
	check code on 32bit
Message-ID: <20090817112410.GA12482@elte.hu>
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu> <4A891E17.1090901@jp.fujitsu.com> <20090817092047.GB21269@elte.hu> <4A893A14.1070103@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A893A14.1070103@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> Ingo Molnar wrote:
>> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
>>
>>> One possibility is: if the BIOS doesn't clear status in banks, new  
>>> mce codes will try to log such junks. If the junk is totally junk  
>>> but can be decoded as a valid log with MISCV or ADDRV bit, and if  
>>> the cpu try to access register which is not implemented (e.g.  
>>> IA32_MCi_MISC/ADDR), then such access might cause a general  
>>> protection exception. (ref. ASDM 3A 15.3.2.3)
>>
>> btw., that reminds me: mce_rdmsrl() needs to be fixed to use  
>> rdmsrl_safe() and it should emit a WARN_ONCE() if it ever hits an  
>> error while trying to access registers.
>
> In general systems (like VMs) who don't have MCA MSRs don't 
> declare the capability bits (there are own capability bits for all 
> of this) and then the MSRs are never touched. So far I've not had 
> a single report of this going wrong.
>
> I suspect the problem on your system is something else too we just 
> need to debug properly.

That sidenote was unrelated to this bug.

We obviously dont #GP fault in the MSR access, i'd see that in the 
crash.

We want to use rdmsr_safe()/wrmsr_safe() in general as a defensive 
measure, for all code that does not actually add functionality but 
is diagnostic (like MCE).

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZIVPml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZIVPml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZIVPml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:42:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41780 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZIVPmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:42:40 -0400
Date: Tue, 22 Sep 2009 17:41:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:x86/mce3] x86, mce: use 64bit machine
	check code on 32bit
Message-ID: <20090922154157.GA17497@elte.hu>
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
> In general systems (like VMs) who don't have MCA MSRs don't declare 
> the capability bits (there are own capability bits for all of this) 
> and then the MSRs are never touched. So far I've not had a single 
> report of this going wrong.

Your sloppiness of not fixing mce_rdmsrl() as i requested brought us 
this new boot crash regression in 2.6.31, in mce_rdmsrl():

   http://bugzilla.kernel.org/show_bug.cgi?id=14204

[    0.010016] mce: CPU supports 5 MCE banks
[    0.011029] general protection fault: 0000 [#1]
[    0.011998] last sysfs file:
[    0.011998] Modules linked in:
[    0.011998]
[    0.011998] Pid: 0, comm: swapper Not tainted (2.6.31_router #1) HP Vectra
[    0.011998] EIP: 0060:[<c100d9b9>] EFLAGS: 00010246 CPU: 0
[    0.011998] EIP is at mce_rdmsrl+0x19/0x60

Here's the deal: from now on i'm not going to take any new MCE patches 
from you unless they are Acked-by Hidetoshi-san or Huang Ying - who in 
the past few months has shown far greater care than you in approaching 
MCE matters.

Your carelessness and your stubborn refusal to learn from past mistakes 
is mind-boggling.

	Ingo

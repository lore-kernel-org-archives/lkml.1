Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbZIXJiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbZIXJiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZIXJin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:38:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55190 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbZIXJii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:38:38 -0400
Date: Thu, 24 Sep 2009 11:38:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Reduce verbosity of "PAT enabled" kernel
	message
Message-ID: <20090924093800.GA23158@elte.hu>
References: <adavdj92sso.fsf@cisco.com> <adar5tx2s9d.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar5tx2s9d.fsf@cisco.com>
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


* Roland Dreier <rdreier@cisco.com> wrote:

> By the way, there is further work to be done in this direction... 
> these were the easy ones (that save me 127 lines of dmesg :).

thanks Roland - i've applied them to tip:x86/urgent, for v2.6.32 merge.

Feel free to send more such patches, they are nice improvements.

> The philosophy should probably be things that we would want to see to 
> debug crashes at boot should go into the kernel log -- that makes it 
> easy for users to grab the output and send it on for debugging.  If we 
> can move other stuff somewhere that users can grab easily after boot, 
> then that's probably worth it.
> 
> I think the next things to look at are:
> 
> * secondary CPU booting:
> 
>      Calibrating delay using timer specific routine.. xxxx BogoMIPS (lpj=xxxx)
>      CPU: Physical Processor ID: 2
>      CPU: Processor Core ID: 0
>      CPU: L1 I cache: xxxx, L1 D cache: xxxx
>      CPU: L2 cache: xxxx
>      CPU: L3 cache: xxxx
>      CPU 1/0x40 -> Node 0
>      mce: CPU supports xxxx MCE banks
>      CPU1: Thermal monitoring enabled (TM1)
>      CPU 1 MCA banks ....
> 
>   where all 64 CPUs are exactly the same -- I guess checking for
>   non-homogenous systems might be kind of complicated but we really
>   shouldn't print all this for every CPU when they all match the boot
>   CPU precisely.

Agreed.

> 
> * scheduler domain stuff:
> 
>      CPU0 attaching sched-domain:
>       domain 0: span 0,32 level SIBLING
>        groups: 0 (cpu_power = xxxx) 32 (cpu_power = xxxx)
>        domain 1: span 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60 level MC
>         groups: 0,32 (cpu_power = xxxx) 4,36 (cpu_power = xxxx) 8,40 (cpu_power = xxxx) 12,44 (cpu_power = xxxx) 16,48 (cpu_power = xxxx) 20,52 (cpu_power = xxxx) 24,56 (cpu_power = xxxx) 28,60 (cpu_power = xxxx)
>         domain 2: span 0-63 level CPU
>          groups: 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60 (cpu_power = xxxx) 1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61 (cpu_power = xxxx) 2,6,10,14,18,22,26,30,34,38,42,46,50,54,58,62 (cpu_power = xxxx) 3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63 (cpu_power = xxxx)
> 
>   not sure what the best way to present this is but 64 copies of this
>   output do consume a lot of log buffer space!

Just turn it off after the first instance and give it a sched=debug boot 
parameter perhaps - that's enough.

> * misc stuff, where we get 64 copies of a single message, eg
> 
>      Switched to high resolution mode on CPU 0
> 
>      ACPI: Processor [CPU0] (supports 8 throttling states)
>      processor LNXCPU:01: registered as cooling_device1

Yeah. The switched-to message could be eliminated altogether.

Thanks,

	Ingo

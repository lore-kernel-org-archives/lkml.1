Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbYKGPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbYKGPOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYKGPOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:14:09 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:53295 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYKGPOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:14:07 -0500
Message-ID: <49145B26.4040701@cosmosbay.com>
Date: Fri, 07 Nov 2008 16:13:42 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Robert Richter <robert.richter@amd.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
References: <4909F690.9090208@cosmosbay.com> <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com> <20081104181855.GK9785@erda.amd.com> <Pine.LNX.4.64.0811042118460.1597@melkki.cs.Helsinki.FI> <4910CD65.1010301@cosmosbay.com> <49113894.5040806@cosmosbay.com> <49130694.7000007@cosmosbay.com> <20081107130249.GN29626@one.firstfloor.org>
In-Reply-To: <20081107130249.GN29626@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 07 Nov 2008 16:13:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> Can you please test this patch and see if it solves the problem?
> 
> Thanks,
> -Andi
> 
> ---
> 
> oprofile: Fix p6 counter overflow check
> 
> Fix the counter overflow check for CPUs with counter width > 32
> 
> I had a similar change in a different patch that I didn't submit
> and I didn't notice the problem earlier because it was always
> tested together.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 

Thanks Andi

Unfortunatly, there is still a freeze of NMIS after a while.

# grep NMI /proc/interrupts
NMI:     127869     439091     905577       6158     809531      54720    4402881    2411582   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:     294473     765839    1174243     282249    1190866     382543    4747495    2463270   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:     294473     899262    1174243     282249    1282407     515973    5139226    2463270   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:     294473     899262    1174243     282249    1282407     515973    5187081    2463270   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:     294473     899262    1174243     282249    1282407     515973    5187081    2463270   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:     294473     899262    1174243     282249    1282407     515973    5187081    2463270   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:     294473     899262    1174243     282249    1282407     515973    5187081    2463270   Non-maskable interrupts
#

# grep . /dev/oprofile/*/*
/dev/oprofile/0/count:10000
/dev/oprofile/0/enabled:1
/dev/oprofile/0/event:60
/dev/oprofile/0/kernel:1
/dev/oprofile/0/unit_mask:0
/dev/oprofile/0/user:1
/dev/oprofile/1/count:0
/dev/oprofile/1/enabled:0
/dev/oprofile/1/event:0
/dev/oprofile/1/kernel:0
/dev/oprofile/1/unit_mask:0
/dev/oprofile/1/user:0
/dev/oprofile/stats/bt_lost_no_mapping:0
/dev/oprofile/stats/event_lost_overflow:376941
/dev/oprofile/stats/sample_lost_no_mapping:43358
/dev/oprofile/stats/sample_lost_no_mm:26

# grep . /dev/oprofile/*
/dev/oprofile/backtrace_depth:0
grep: /dev/oprofile/buffer: Device or resource busy
/dev/oprofile/buffer_size:1048576
/dev/oprofile/buffer_watershed:32768
/dev/oprofile/cpu_buffer_size:65536
/dev/oprofile/cpu_type:i386/core_2
grep: /dev/oprofile/dump: Invalid argument
/dev/oprofile/enable:1
/dev/oprofile/pointer_size:4



> ---
>  arch/x86/oprofile/op_model_ppro.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.28-rc3-test/arch/x86/oprofile/op_model_ppro.c
> ===================================================================
> --- linux-2.6.28-rc3-test.orig/arch/x86/oprofile/op_model_ppro.c	2008-11-07 13:46:23.000000000 +0100
> +++ linux-2.6.28-rc3-test/arch/x86/oprofile/op_model_ppro.c	2008-11-07 13:50:57.000000000 +0100
> @@ -27,8 +27,7 @@
>  static int counter_width = 32;
>  
>  #define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
> -#define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
> -#define CTR_OVERFLOWED(n) (!((n) & (1U<<(counter_width-1))))
> +#define CTR_OVERFLOWED(n) (!((n) & (1ULL<<(counter_width-1))))
>  
>  #define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
>  #define CTRL_READ(l, h, msrs, c) do {rdmsr((msrs->controls[(c)].addr), (l), (h)); } while (0)
> @@ -124,14 +123,14 @@
>  static int ppro_check_ctrs(struct pt_regs * const regs,
>  			   struct op_msrs const * const msrs)
>  {
> -	unsigned int low, high;
> +	u64 val;
>  	int i;
>  
>  	for (i = 0 ; i < num_counters; ++i) {
>  		if (!reset_value[i])
>  			continue;
> -		CTR_READ(low, high, msrs, i);
> -		if (CTR_OVERFLOWED(low)) {
> +		rdmsrl(msrs->counters[i].addr, val);
> +		if (CTR_OVERFLOWED(val)) {
>  			oprofile_add_sample(regs, i);
>  			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
>  		}
> 
> 



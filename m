Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZB1IVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZB1IVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZB1IVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:21:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39856 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbZB1IVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:21:37 -0500
Date: Sat, 28 Feb 2009 09:21:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 1/2] x86_32: summit_32, use BAD_APICID
Message-ID: <20090228082120.GA11425@elte.hu>
References: <20090224175518.GA15616@elte.hu> <1235508093-18063-1-git-send-email-jirislaby@gmail.com> <49A524D3.3090408@gmail.com> <20090225111002.GA15453@elte.hu> <49A71105.4050001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A71105.4050001@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> On 25.2.2009 12:10, Ingo Molnar wrote:
>> * Jiri Slaby<jirislaby@gmail.com>  wrote:
>>> In that case, the callers code is buggy, since it passes
>>> online_cpu masks even on machines, where apics are not on the
>>> same clusters.
>>
>> It's most likely confusion in the old code. This used to be
>> copy&paste-ed versions of different snapshots of the
>> mach-default-code, hacked to make work on weird platforms.
>> Mainline fixes/updates werent merged in consistently.
>>
>> So could you please send a patch that fixes this?
>
> I've sent 4 more patches, but there are still issues:
> * es7000 + summit: I haven't solved calling with all bits set (only all  
> online is sufficient to trigger this). Some of the processors needn't be  
> on the same apic cluster. It will scream now (again -- it did before  
> adding the "optimisation"). Actually I don't know how to solve this. How  
> the caller would know the correct mask, ANDing with a apic->target_cpus  
> retval?
>
> * es7000: target_cpus_cluster returns CPU_MASK_ALL and hence it will  
> choke itself, because es7000_cpu_mask_to_apicid doesn't count with that.  
> Invoked by setup_timer_IRQ0_pin this way.
>
> * set_desc_affinity doesn't expect apic->cpu_mask_to_apicid_and to  
> return BAD_APICID and silently sets desc->affinity. Again, I see no  
> straightforward solution (rollback of assign_irq_vector and  
> set_extra_move_desc needed).

Ok, they look good. I got a conflict in 2/4, due to an 
interacting cleanup from Yinghai - mind resending them against 
latest tip:master?

Thanks,

	Ingo

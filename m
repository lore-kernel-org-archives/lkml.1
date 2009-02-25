Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbZBYLK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbZBYLK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZBYLKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:10:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33575 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZBYLKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:10:19 -0500
Date: Wed, 25 Feb 2009 12:10:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 1/2] x86_32: summit_32, use BAD_APICID
Message-ID: <20090225111002.GA15453@elte.hu>
References: <20090224175518.GA15616@elte.hu> <1235508093-18063-1-git-send-email-jirislaby@gmail.com> <49A524D3.3090408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A524D3.3090408@gmail.com>
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

> On 24.2.2009 21:41, Jiri Slaby wrote:
>> --- a/arch/x86/kernel/apic/summit_32.c
>> +++ b/arch/x86/kernel/apic/summit_32.c
>> @@ -303,12 +303,10 @@ static inline unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
>>   	int cpu;
>>
>>   	num_bits_set = cpus_weight(*cpumask);
>> -	/* Return id to all */
>>   	if (num_bits_set>= nr_cpu_ids)
>> -		return 0xFF;
>> +		return BAD_APICID;
>
> Actually, wasn't this intended to return all available rather 
> than BAD (to which would correspond the comment), but 
> performed in a wrong manner? This is old code, any ideas who 
> would know this?
>
> In my opinion the check should be removed completely to allow 
> the code go through same-cluster check.
>
> In that case, the callers code is buggy, since it passes 
> online_cpu masks even on machines, where apics are not on the 
> same clusters.

It's most likely confusion in the old code. This used to be 
copy&paste-ed versions of different snapshots of the 
mach-default-code, hacked to make work on weird platforms. 
Mainline fixes/updates werent merged in consistently.

So could you please send a patch that fixes this?

	Ingo

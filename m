Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZI2I26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZI2I26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 04:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZI2I26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 04:28:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZI2I25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 04:28:57 -0400
Message-ID: <4AC1C557.2050002@redhat.com>
Date: Tue, 29 Sep 2009 10:29:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2: kvm 2/4] Kill the confusing tsc_ref_khz and ref_freq
 variables.
References: <1254197072-889-1-git-send-email-zamsden@redhat.com> <1254197072-889-2-git-send-email-zamsden@redhat.com> <1254197072-889-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1254197072-889-3-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 06:04 AM, Zachary Amsden wrote:
> They are globals, not clearly protected by any ordering or locking, and
> vulnerable to various startup races.
>
> Instead, for variable TSC machines, register the cpufreq notifier and get
> the TSC frequency directly from the cpufreq machinery.  Not only is it
> always right, it is also perfectly accurate, as no error prone measurement
> is required.
>
> On such machines, when a new CPU online is brought online, it isn't clear what
> frequency it will start with, and it may not correspond to the reference, thus
> in hardware_enable we clear the cpu_tsc_khz variable to zero and make sure
> it is set before running on a VCPU.
>
>   					  CPUFREQ_TRANSITION_NOTIFIER);
> +		for_each_online_cpu(cpu)
> +			per_cpu(cpu_tsc_khz, cpu) = cpufreq_get(cpu);
> +	} else {
> +		for_each_possible_cpu(cpu)
> +			per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
> +	}
> +	for_each_possible_cpu(cpu) {
> +		printk(KERN_DEBUG "kvm: cpu %d = %ld khz\n",
> +			cpu, per_cpu(cpu_tsc_khz, cpu));
>   	}
>   }
>    

Leftover debug code?

-- 
error compiling committee.c: too many arguments to function


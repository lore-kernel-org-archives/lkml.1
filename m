Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbZBTCqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbZBTCqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZBTCqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:46:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:46857 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZBTCqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:46:09 -0500
Message-ID: <499E1966.9020405@kernel.org>
Date: Fri, 20 Feb 2009 11:45:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-10-git-send-email-tj@kernel.org> <20090219021015.aac6ea43.akpm@linux-foundation.org> <20090219110142.GH2354@elte.hu>
In-Reply-To: <20090219110142.GH2354@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Feb 2009 02:45:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>>> + * To use this allocator, arch code should do the followings.
>>> + *
>>> + * - define CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
>>> + *
>>> + * - define __addr_to_pcpu_ptr() and __pcpu_ptr_to_addr() to translate
>>> + *   regular address to percpu pointer and back
>>> + *
>>> + * - use pcpu_setup_static() during percpu area initialization to
>>> + *   setup kernel static percpu area
>>> + */
>> afacit nobody has answered your "is num_possible_cpus() ever a 
>> lot larger than num_online_cpus()" question.
>>
>> It is fairly important.
> 
> yeah.
> 
> On x86 we limit num_possible_cpus() at boot time from NR_CPUS to 
> the BIOS-enumerated set of possible CPUs - i.e. the two will 
> always be either equal, or be very close to each other.
> 
> ( there used to be broken early BIOSes that enumerated more CPUs 
>   than needed but it's very rare and because it also wastes BIOS 
>   RAM/ROM it's something they'll usually avoid even if they dont 
>   care about Linux. )
> 
> So this should be a pretty OK assumption.

Hmm... this is a confusing conversation.  Andrew seems to say that not
allocating memory for offline cpus is fairly important and Ingo's
reply starts with yeah but draws the opposite conclusion.  Or my
English failing me again?

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYCZQME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYCZQME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbYCZQLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:11:55 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51547 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755221AbYCZQLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:11:54 -0400
Message-ID: <47EA75C7.7020506@sgi.com>
Date: Wed, 26 Mar 2008 09:11:51 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 01/10] x86_64: Cleanup non-smp usage of cpu maps v2
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.011213000@polaris-admin.engr.sgi.com> <20080326064045.GF18301@elte.hu>
In-Reply-To: <20080326064045.GF18301@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Cleanup references to the early cpu maps for the non-SMP configuration 
>> and remove some functions called for SMP configurations only.
> 
> thanks, applied.
> 
> one observation:
> 
>> +#ifdef CONFIG_SMP
>>  extern int x86_cpu_to_node_map_init[];
>>  extern void *x86_cpu_to_node_map_early_ptr;
>> +#else
>> +#define x86_cpu_to_node_map_early_ptr NULL
>> +#endif
> 
> Right now all these early_ptrs are in essence open-coded "early 
> per-cpu", right? But shouldnt we solve that in a much cleaner way: by 
> explicitly adding an early-per-cpu types and accessors, and avoid all 
> that #ifdeffery?
> 
> 	Ingo

I was thinking of something similar but had to put it on the back
burner until we got to the point of being able to boot a kernel
with NR_CPUS set to 4096.  It should pop back up on the priority
queue very soon... ;-)

Thanks!
Mike

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbYG1Smb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbYG1Smb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYG1SmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:42:24 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38777 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753511AbYG1SmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:42:23 -0400
Message-ID: <488E130E.9060108@sgi.com>
Date: Mon, 28 Jul 2008 11:42:22 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [git pull] cpus4096 fixes
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <20080727210350.GA30033@elte.hu>
In-Reply-To: <20080727210350.GA30033@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
...
> NUMA-locality might have been a valid argument in favor of the massive 
> array of constant cpumasks (common usage is to use it for the current 
> cpu), if it wasnt all stupidly allocated on the boot node:
> 
>         cpumask_of_cpu_map = alloc_bootmem_low(sizeof(cpumask_t) * nr_cpu_ids);
>         for (i = 0; i < nr_cpu_ids; i++)
>                 cpu_set(i, cpumask_of_cpu_map[i]);

The alternate method was for each cpu to contribute a cpumask_of_cpu
for itself in the percpu area.  I don't recall why that idea was rejected.

But yes, the set_cpus_allowed is the biggest receiver of cpumask_t's with
a single bit set.  I had also proposed a different interface allowing just
that, but I think it was rejected as being redundant.

Thanks,
Mike

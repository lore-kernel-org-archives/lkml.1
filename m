Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab0CCENU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 23:13:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:41061 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0CCENT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 23:13:19 -0500
Message-ID: <4B8DE479.1030308@kernel.org>
Date: Wed, 03 Mar 2010 13:24:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: werner@guyane.dyn-o-saur.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 problems
References: <1267587210.10602@guyane.dyn-o-saur.com>
In-Reply-To: <1267587210.10602@guyane.dyn-o-saur.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Mar 2010 04:13:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/03/2010 12:33 PM, werner@guyane.dyn-o-saur.com wrote:
> dmesg isn't complete.  That's a general problem.  When we get 1 GB
> dmesg buffer in the kernel config ????

Kernel log can be incomplete for many reasons.  In your case klogd
wasn't logging debug messages so I couldn't see pcpu debug info.
dmesg w/ sufficiently large -s combined with large kernel buffer
usually works.

> Linux version 2.6.33-git7 (root@werner) (gcc version 4.3.3 (GCC) ) #1 SMP PREEMPT Tue Mar 2 06:15:19 GFT 2010
...
> setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
> PERCPU: Embedded 14 pages/cpu @c3c00000 s35876 r0 d21468 u2097152
> pcpu-alloc: s35876 r0 d21468 u2097152 alloc=1*4194304
> pcpu-alloc: [0] 0 1 

Here, the unit size is 2M and the chunk size 4M for the two possible
cpus.  This isn't excessive at all and i386 shouldn't have much
problem accomodating it.  Have you tried percpu_alloc=page?

Thanks.

-- 
tejun

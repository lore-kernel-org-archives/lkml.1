Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbXIQPbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbXIQPbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 11:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbXIQPbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 11:31:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56848 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756393AbXIQPbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 11:31:10 -0400
Message-ID: <46EE9BCF.3040303@sgi.com>
Date: Mon, 17 Sep 2007 08:22:55 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH 09/10] ppc64: Convert cpu_sibling_map to a per_cpu data
 array (v3)
References: <20070912015644.927677070@sgi.com>	<20070912015647.486500682@sgi.com> <20070917162831.b2a9d675.sfr@canb.auug.org.au>
In-Reply-To: <20070917162831.b2a9d675.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> On Tue, 11 Sep 2007 18:56:53 -0700 travis@sgi.com wrote:
>> Convert cpu_sibling_map to a per_cpu cpumask_t array for the ppc64
>> architecture.  This fixes build errors in block/blktrace.c and
>> kernel/sched.c when CONFIG_SCHED_SMT is defined.
>>
>> Note: these changes have not been built nor tested.
> 
> After applying all 10 patches, the ppc64_defconfig builds but:
> 
> 	vmlinux is larger:
> 
>    text    data     bss     dec     hex filename
> 7705776 1756984  504624 9967384  981718 ppc64/vmlinux
> 7706228 1757120  504624 9967972  981964 trav.bld/vmlinux
> 
> 	the topology (on my POWERPC5+ box) is not correct:
> 
> cpu0/topology/thread_siblings:0000000f
> cpu1/topology/thread_siblings:0000000f
> cpu2/topology/thread_siblings:0000000f
> cpu3/topology/thread_siblings:0000000f
> 
> it used to be:
> 
> cpu0/topology/thread_siblings:00000003
> cpu1/topology/thread_siblings:00000003
> cpu2/topology/thread_siblings:0000000c
> cpu3/topology/thread_siblings:0000000c
> 
> Similarly on my iSeries box, the topology is displayed as above
> while it used to be:
> 
> cpu0/topology/thread_siblings:00000001
> cpu1/topology/thread_siblings:00000002
> cpu2/topology/thread_siblings:00000004
> cpu3/topology/thread_siblings:00000008
> 

Thanks Stephen for the feedback.  It may be the same situation
that some of the other arch's encounter in that the per_cpu
area is being accessed before it's setup.  I'll investigate
that a bit more.

Mike

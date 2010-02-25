Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab0BYCOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 21:14:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:39352 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab0BYCOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 21:14:10 -0500
Message-ID: <4B85DCAF.5030304@kernel.org>
Date: Wed, 24 Feb 2010 18:13:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 16/35] x86: make 64 bit use early_res instead of bootmem
 before slab
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>	 <1265793639-15071-17-git-send-email-yinghai@kernel.org>	 <20100215010833.15f9e09a.sfr@canb.auug.org.au>	 <4B7B4378.1070206@kernel.org> <1267052387.12790.10.camel@laptop> <4B85B65E.503@kernel.org> <4B85B724.9050304@kernel.org> <4B85DB79.4010708@kernel.org>
In-Reply-To: <4B85DB79.4010708@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2010 06:07 PM, Tejun Heo wrote:
> Hello, Yinghai.
> 
> On 02/25/2010 08:32 AM, Yinghai Lu wrote:
>>>> Kernel panic - not syncing: free_early on not reserved area: 2f80000-2f9ffff!
>>>> Pid: 0, comm: swapper Not tainted 2.6.33-rc8-tip-00918-gb34d361 #159
>>>> Call Trace:	
>>>>  [<ffffffff815d12e2>] panic+0x84/0x147
>>>>  [<ffffffff81cceecb>] free_early+0x64/0x6d
>>>>  [<ffffffff81cd2231>] free_bootmem+0xc/0xe
>>>>  [<ffffffff81cc1cd6>] pcpu_fc_free+0x1d/0x1f
>>>>  [<ffffffff81cd6056>] pcpu_embed_first_chunk+0x13a/0x27f
>>>>  [<ffffffff81cc1cd8>] ? pcpu_fc_alloc+0x0/0xac
>>>>  [<ffffffff81cc1cb9>] ? pcpu_fc_free+0x0/0x1f
>>>>  [<ffffffff81cc1af7>] setup_per_cpu_areas+0x82/0x239
>>>>  [<ffffffff81cb5b3c>] start_kernel+0x1b8/0x43b
>>>>  [<ffffffff81cb52bc>] x86_64_start_reservations+0xa7/0xab
>>>>  [<ffffffff81cb53b8>] x86_64_start_kernel+0xf8/0x107
>>>>
>>>
>>> we can not handle partial free, and current only user for that is pcpu_setup...
>>
>> any plan to pcpu_setup to use slab allocation instead of bootmem?
>> that code is only one user that do partial bootmem free.
> 
> The problem is that the pcpu_embed_first_chunk() allocator depends on
> having a large contiguous slab of memory to overlay the percpu
> variables and then giving back the unused parts (due to layout and
> cpu_possible_mask not being contiguous).  There's no way to do partial
> alloc/free anymore?

ok, will add free_early_partial to handle it.

i got impression, when we are moving slab ealier.
you said that will check to make percpu setup to use slab allocator instead.

YH

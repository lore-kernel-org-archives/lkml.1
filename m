Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZBDJeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZBDJeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZBDJd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:33:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZBDJd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:33:57 -0500
Message-ID: <4989606F.9030804@cn.fujitsu.com>
Date: Wed, 04 Feb 2009 17:31:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the
 unallowed node when memory spread is set
References: <4976D77C.3020107@cn.fujitsu.com>	 <20090127144233.18cf9b3f.akpm@linux-foundation.org>	 <4987B925.1010405@cn.fujitsu.com>	 <20090203141645.91c7ea18.akpm@linux-foundation.org> <6599ad830902031449j1fa3dd08re842b57f8700b389@mail.gmail.com>
In-Reply-To: <6599ad830902031449j1fa3dd08re842b57f8700b389@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2009-2-4 6:49 Paul Menage wrote:
> On Tue, Feb 3, 2009 at 2:16 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Tue, 03 Feb 2009 11:25:25 +0800
>> Miao Xie <miaox@cn.fujitsu.com> wrote:
[snip]
>>
>> I wasn't able to find out where the setting of init'smems_allowed
>> happens, after a bit of grepping and hunting.  It should be done within
>> INIT_TASK, but isn't.
>>
>> Still, kthreadd is reliably parented by swapper, and there shold be no
>> need to alter its mems_allowed.
>>
>> Similarly, what was the reason for setting current->mems_allowed in
>> kernel_init()?  That also should be unneeded.
>>
>> Finally, I've somewhat lost track of where we are with this patch.
>> Paul, do you see any other remaining issues?
> 
> AFAICS this patch still has a race between a thread reading its
> mems_allowed, and another thread updating it. The current architecture
> of having task->mems_allowed be only updatable by current was PaulJ's
> code originally, and I'm a bit loathe to touch it. But if we're going
> to, we'll need at the minimum to add a lock for any code that touches
> current->mems_allowed.

Agree! But mems_allowed is touched in the module of memory management
in general, adding a lock to protect mems_allowed may lead to performance
regression.

> 
> Paul
> 
> 
> 



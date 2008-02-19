Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbYBSNTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbYBSNTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYBSNTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:19:31 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:54086 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbYBSNTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:19:30 -0500
Message-ID: <47BAD75C.9030406@linux.vnet.ibm.com>
Date: Tue, 19 Feb 2008 18:49:24 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] Linux 2.6.25-rc2 - Regression from 2.6.24-rc1-git1 softlockup
  while bootup on powerpc
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <47B67E5E.4010001@linux.vnet.ibm.com> <20080217192913.GO23197@kernel.dk> <20080219170432.9c04376f.kamezawa.hiroyu@jp.fujitsu.com> <20080219083633.GN23197@kernel.dk>
In-Reply-To: <20080219083633.GN23197@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Feb 19 2008, KAMEZAWA Hiroyuki wrote:
>> On Sun, 17 Feb 2008 20:29:13 +0100
>> Jens Axboe <jens.axboe@oracle.com> wrote:
>>
>>> It's odd stuff. Could you perhaps try and add some printks to
>>> block/cfq-iosched.c:call_for_each_cic(), like dumping the 'nr' return
>>> from radix_tree_gang_lookup() and the pointer value of cics[i] in the
>>> for() loop after the lookup?
>>>
>> I met the same issue on ia64/NUMA box.
>> seems cisc[]->key is NULL and index for radix_tree_gang_lookup() was
>> always '1'.
> 
> Why does it keep repeating then? If ->key is NULL, the next lookup index
> should be 1UL.
> 
> But I think the radix 'scan over entire tree' is a bit fragile. This
> patch adds a parallel hlist for ease of properly browsing the members,
> does that work for you? It compiles, but I haven't booted it here yet...
> 
>> Attached patch works well for me, but I don't know much about cfq.
>> please confirm. 
> 
> It doesn't make a lot of sense, I'm afraid.
> 
>  block/blk-ioc.c           |   35 +++++++++++++++--------------------
>  block/cfq-iosched.c       |   37 +++++++++++--------------------------
>  include/linux/iocontext.h |    2 ++
>  3 files changed, 28 insertions(+), 46 deletions(-)
> 
> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> index 80245dc..73c7002 100644
> --- a/block/blk-ioc.c

<snip>

Hi Jens,

Thanks for the patch. The patch works fine, machine boots up without the kernel panic.


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

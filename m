Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYKJJDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYKJJDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYKJJDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:03:34 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:9021 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbYKJJDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:03:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TdFRbf6RjoRkU14iFzvOhS+isIYQs3s+F6nyYPyhEkAUCQWhvkbKd4lz1E+LNhUJQz
         vLLOGcd+VQcmze5hPdDlACadi/FVSlzRpWwUbumsnH+KL5IbhBC++KiXGQ6wYLJCV+mp
         6ZHx2I/3+AJukEIbCAsKfi3iSs/ZV5JZM0zoc=
Message-ID: <4917F895.109@gmail.com>
Date: Mon, 10 Nov 2008 10:02:13 +0100
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, rientjes@google.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, peterz@infradead.org,
       npiggin@suse.de, menage@google.com, dfults@sgi.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 0/7] cpuset writeback throttling
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>	<20081104124753.fb1dde5a.akpm@linux-foundation.org>	<1225831988.7803.1939.camel@twins>	<20081104131637.68fbe055.akpm@linux-foundation.org>	<1225833710.7803.1993.camel@twins>	<20081104135004.f1717fcf.akpm@linux-foundation.org>	<Pine.LNX.4.64.0811041601100.5077@quilx.com>	<20081104143534.b5c16147.akpm@linux-foundation.org>	<Pine.LNX.4.64.0811041648350.6254@quilx.com>	<20081104153610.bbfd5ed8.akpm@linux-foundation.org>	<Pine.LNX.4.64.0811042036000.31167@quilx.com>	<20081104190505.769b93ec.akpm@linux-foundation.org> <20081105133157.db8bae72.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081105133157.db8bae72.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-05 05:31, KAMEZAWA Hiroyuki wrote:
> On Tue, 4 Nov 2008 19:05:05 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>> Generally, I worry that this is a specific fix to a specific problem
>> encountered on specific machines with specific setups and specific
>> workloads, and that it's just all too low-level and myopic.
>>
>> And now we're back in the usual position where there's existing code and
>> everyone says it's terribly wonderful and everyone is reluctant to step
>> back and look at the big picture.  Am I wrong?
>>
>>
>> Plus: we need per-memcg dirty-memory throttling, and this is more
>> important than per-cpuset, I suspect.  How will the (already rather
>> buggy) code look once we've stuffed both of them in there?
>>
>>
> IIUC, Andrea Righ posted 2 patches around dirty_ratio. (added him to CC:)
> in early October.
> 
>   (1) patch for adding dirty_ratio_pcm. (1/100000)
>   (2) per-memcg dirty ratio. (maybe this..http://lkml.org/lkml/2008/9/12/121)
>  
> (1) should be just posted again.
> 
> Because we have changed page_cgroup implementation, (2) should be reworked.
> "rework" itself will not be very difficult.
> (.... we tend to be stick to "what interface is the best" discussion ;) 
> 
> But memcg itself is not so weak against dirty_pages because we don't call
> try_to_free_pages() becasue of memory shortage but because of memory limitation.
> 
> BTW, in my current stack, followings are queued.
>    a. handle SwapCache in proper way in memcg.
>    b. handle swap_cgroup (if configured)
>    c. make LRU handling easier
> 
> For making per-memcg dirty_ratio sane, (a) should go ahead. I do (a) now.
> If Andrea seems to be too busy, I'll schedule dirty_ratio-for-memcg as my work.
> 

Hi Kame,

sorry for my late. If it's not too late tonight I'll rebase and test (1)
to 2.6.28-rc2-mm1 and start to rework on (2), also considering the
David's suggestion (split NR_UNSTABLE_NFS from NR_FILE_DIRTY).

-Andrea

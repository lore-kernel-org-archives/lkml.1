Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbYIEJp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbYIEJp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYIEJpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:45:17 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:51938 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYIEJpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:45:16 -0400
Message-ID: <48C0FF9F.3060803@linux.vnet.ibm.com>
Date: Fri, 05 Sep 2008 15:15:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "menage@google.com" <menage@google.com>
Subject: Re: [PATCH][mmotm]memcg: handle null dereference of mm->owner
References: <20080905165017.b2715fe4.nishimura@mxp.nes.nec.co.jp> <20080905174021.9fa29b01.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080905174021.9fa29b01.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 5 Sep 2008 16:50:17 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
>> Hi.
>>
>> mm_update_next_owner() may clear mm->owner to NULL
>> if it races with swapoff, page migration, etc.
>> (This behavior was introduced by mm-owner-fix-race-between-swap-and-exit.patch.)
>>
>> But memcg doesn't take account of this situation, and causes:
>>
>>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000630
>>
>> This fixes it.
>>
> Thank you for catching this.
> 

Thanks, Daisuke

> BTW, I have a question to Balbir and Paul. (I'm sorry I missed the discussion.)
> Recently I wonder why we need MM_OWNER.
> 
> - What's bad with thread's cgroup ?
> - Why we can't disallow per-thread cgroup under memcg ?)
> 


For the following reasons, I had initially designed it to be that way because

1. There is no concept of a thread maintaining or managing its memory
independently of others
2. If we ever support full migration, it is easier to do so with the thread
group leader owning the memory, rather than figuring out what to do everytime a
task changed a cgroup.
3. A task with appropriate permissions can spread itself across cgroups and hog
memory


-- 
	Balbir

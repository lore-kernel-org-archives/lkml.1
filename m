Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYHHJla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYHHJla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYHHJlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:41:20 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:36199 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYHHJlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:41:19 -0400
Message-ID: <489C150C.5040700@oss.ntt.co.jp>
Date: Fri, 08 Aug 2008 18:42:36 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org
Subject: Re: [PATCH 6/7] bio-cgroup: Implement the bio-cgroup
References: <20080804.175934.112619046.ryov@valinux.co.jp>	<20080804.180022.183027902.ryov@valinux.co.jp>	<489BF14D.6050009@oss.ntt.co.jp> <20080808.173045.112614776.ryov@valinux.co.jp>
In-Reply-To: <20080808.173045.112614776.ryov@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tsuruta-san,

Ryo Tsuruta wrote:
> Hi Yoshikawa-san,
> 
>>> +static void bio_cgroup_move_task(struct cgroup_subsys *ss,
>>> +				struct cgroup *cont,
>>> +				struct cgroup *old_cont,
>>> +				struct task_struct *p)
>>> +{
>>> +	struct mm_struct *mm;
>>> +	struct bio_cgroup *biog, *old_biog;
>>> +
>>> +	if (bio_cgroup_disabled())
>>> +		return;
>>> +
>>> +	mm = get_task_mm(p);
>>> +	if (mm == NULL)
>>> +		return;
>>> +
>>> +	biog = cgroup_bio(cont);
>>> +	old_biog = cgroup_bio(old_cont);
>>> +
>>> +	mmput(mm);
>>> +	return;
>>> +}
>> Is this function fully implemented?
> 
> This function can be more simplified, there is some unnecessary code 
> from old version.
> 

I think it is neccessary to attach the task p to new biog.

>> I tried to put a process into a group by writing to
>> "/cgroup/bio/BGROUP/tasks" but failed.
> 
> Could you tell me what you actually did? I will try the same thing.
> 
> --
> Ryo Tsuruta <ryov@valinux.co.jp>
> 

I wanted to test my own scheduler which uses bio tracking information.
SO I tried your patch, especially, get_bio_cgroup_iocontext(), to get
the io_context from bio.

In my test, I made some threads with certain iopriorities run 
concurrently. To schedule these threads based on their iopriorities,
I made BGROUP directories for each iopriorities.
e.g. /cgroup/bio/be0 ... /cgroup/bio/be7
Then, I tried to attach the processes to the appropriate groups.

But the processes stayed in the original group(id=0).
...

I am sorry but I have to leave now and I cannot come here next week.
--> I will take summer holidays.

I will reply to you later.

Thanks,
- Takuya Yoshikawa

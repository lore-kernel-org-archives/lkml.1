Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbXKWJap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbXKWJap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 04:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbXKWJag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 04:30:36 -0500
Received: from sacred.ru ([62.205.161.221]:51517 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbXKWJaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 04:30:35 -0500
Message-ID: <47469CF3.1030200@openvz.org>
Date: Fri, 23 Nov 2007 12:27:15 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Pierre Peiffer <pierre.peiffer@bull.net>
CC: Cedric Le Goater <clg@fr.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [PATCH 2.6.24-rc3-mm1] IPC: make struct ipc_ids static in ipc_namespace
References: <20071122155448.3193c856.pierre.peiffer@bull.net> <474680B5.7020104@fr.ibm.com> <47468347.5090303@openvz.org> <47468927.3040304@openvz.org> <47469630.3060807@bull.net>
In-Reply-To: <47469630.3060807@bull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 23 Nov 2007 12:27:17 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Peiffer wrote:
> Hi,
> 
> 	Thanks for reviewing this !
> 
> Pavel Emelyanov wrote:
>> Pavel Emelyanov wrote:
>>> Cedric Le Goater wrote:
>>>> Pierre Peiffer wrote:
>> [snip]
>>
>>>> Pavel, what do you think of it ? 
>>> Looks sane, good catch, Pierre.
>>>
>>> But I'd find out whether these three ipc_ids intersect any 
>>> cache-line. In other words I'd mark the struct ipc_ids as
>>> ____cacheline_aligned and checked for any differences.
>> BTW! It might be also useful to keep ipc_ids closer to their
>> sysctl parameters.
>>
> 
> It makes sense indeed.
> 
> That would mean to have something like this, right ?

Yup :)

> struct ipc_namespace {
> 	struct kref	kref;
> 
> 	struct ipc_ids	sem_ids;
> 	int		sem_ctls[4];
> 	int		used_sems;
> 
> 	struct ipc_ids	msg_ids;
> 	int		msg_ctlmax;
> 	int		msg_ctlmnb;
> 	int		msg_ctlmni;
> 	atomic_t	msg_bytes;
> 	atomic_t	msg_hdrs;
> 
> 	struct ipc_ids	shm_ids;
> 	size_t		shm_ctlmax;
> 	size_t		shm_ctlall;
> 	int		shm_ctlmni;
> 	int		shm_tot;
> };
> 
> After a quick look, that implies to rework a little bit procfs... othwise, it's
> not a big deal as I can see.

Thanks!

> P.
> 
>>>> Acked-by: Cedric Le Goater <clg@fr.ibm.com>
>>>>
>>>> Thanks,
>>> Thanks,
>>> Pavel
>>>
>>>> C.
>> [snip]
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 


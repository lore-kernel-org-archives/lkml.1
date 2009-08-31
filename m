Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZHaR4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZHaR4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZHaR4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:56:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbZHaR4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:56:41 -0400
Message-ID: <4A9C0E64.8000401@redhat.com>
Date: Mon, 31 Aug 2009 13:54:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 20/23] io-controller: Per cgroup request descriptor support
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-21-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-21-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o Currently a request queue has got fixed number of request descriptors for
>   sync and async requests. Once the request descriptors are consumed, new
>   processes are put to sleep and they effectively become serialized. Because
>   sync and async queues are separate, async requests don't impact sync ones
>   but if one is looking for fairness between async requests, that is not
>   achievable if request queue descriptors become bottleneck.
> 
> o Make request descriptor's per io group so that if there is lots of IO
>   going on in one cgroup, it does not impact the IO of other group.
> 
> o This patch implements the per cgroup request descriptors. request pool per
>   queue is still common but every group will have its own wait list and its
>   own count of request descriptors allocated to that group for sync and async
>   queues. So effectively request_list becomes per io group property and not a
>   global request queue feature.
> 
> o Currently one can define q->nr_requests to limit request descriptors
>   allocated for the queue. Now there is another tunable q->nr_group_requests
>   which controls the requests descriptr limit per group. q->nr_requests
>   supercedes q->nr_group_requests to make sure if there are lots of groups
>   present, we don't end up allocating too many request descriptors on the
>   queue.
> 
> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

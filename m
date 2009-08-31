Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbZHaRkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbZHaRkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZHaRkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:40:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZHaRke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:40:34 -0400
Message-ID: <4A9C0AEB.6000506@redhat.com>
Date: Mon, 31 Aug 2009 13:39:55 -0400
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
Subject: Re: [PATCH 19/23] io-controller: map async requests to appropriate
 cgroup
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-20-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-20-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o So far we were assuming that a bio/rq belongs to the task who is submitting
>   it. It did not hold good in case of async writes. This patch makes use of
>   blkio_cgroup pataches to attribute the aysnc writes to right group instead
>   of task submitting the bio.
> 
> o For sync requests, we continue to assume that io belongs to the task
>   submitting it. Only in case of async requests, we make use of io tracking
>   patches to track the owner cgroup.
> 
> o So far cfq always caches the async queue pointer. With async requests now
>   not necessarily being tied to submitting task io context, caching the
>   pointer will not help for async queues. This patch introduces a new config
>   option CONFIG_TRACK_ASYNC_CONTEXT. If this option is not set, cfq retains
>   old behavior where async queue pointer is cached in task context. If it
>   is set, async queue pointer is not cached and we take help of bio
>   tracking patches to determine group bio belongs to and then map it to
>   async queue of that group.
> 
> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>


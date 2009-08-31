Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZHaRWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZHaRWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZHaRWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:22:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbZHaRWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:22:06 -0400
Message-ID: <4A9C068C.2020008@redhat.com>
Date: Mon, 31 Aug 2009 13:21:16 -0400
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
Subject: Re: [PATCH 17/23] io-controller: anticipatory changes for hierarchical
 fair queuing
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-18-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-18-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> This patch changes anticipatory scheduler to use queue scheduling code from
> elevator layer.  One can go back to old as by deselecting
> CONFIG_IOSCHED_AS_HIER. Even with CONFIG_IOSCHED_AS_HIER=y, with-out any
> other cgroup created, AS behavior should remain the same as old.
> 
> o AS is a single queue ioschduler, that means there is one AS queue per group.
> 
> o common layer code select the queue to dispatch from based on fairness, and
>   then AS code selects the request with-in group.
> 
> o AS runs reads and writes batches with-in group. So common layer runs timed
>   group queues and with-in group time, AS runs timed batches of reads and
>   writes.
> 
> o Note: Previously AS write batch length was adjusted synamically whenever
>   a W->R batch data direction took place and when first request from the
>   read batch completed.
> 
>   Now write batch updation takes place when last request from the write
>   batch has finished during W->R transition.
> 
> o AS runs its own anticipation logic to anticipate on reads. common layer also
>   does the anticipation on the group if think time of the group is with-in
>   slice_idle.
> 
> o Introduced few debugging messages in AS.
> 
> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>


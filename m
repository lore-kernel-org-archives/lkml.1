Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbZCQGb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbZCQGb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 02:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbZCQGbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 02:31:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50665 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZCQGbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 02:31:19 -0400
Message-ID: <49BF43A8.1040808@jp.fujitsu.com>
Date: Tue, 17 Mar 2009 15:31:04 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] posixtimers: Fix posix clock monotonicity
References: <49BF3F73.5090007@jp.fujitsu.com> <20090317151632.a84528b0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090317151632.a84528b0.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> 
>> This patch rehires task_sched_runtime() and thread_group_sched_runtime()
>> which were removed at the time of 2.6.28-rc1.
>>
>> These functions protect the sampling of clock with rq lock.
>> This rq lock is required not to update rq->clock during the sampling.
>> i.e. You may get ((banked runtime before update)+(delta after update)).
>>
> Does clock_gettime() go backward without lock ?

Yes, that's right.

You can find the ancestor of this patch here:
 [RESEND][PATCH] posixtimers: clock_gettime(CLOCK_*_CPUTIME_ID) goes backward
  http://lkml.org/lkml/2009/1/27/18

After the last post, I dug the git-log and found that there were functions,
task_sched_runtime() and thread_group_sched_runtime(), worked fine at the
time of 2.6.27.  I think it is better to reintroduce these functions again
than making almost same function with different name.

Thanks,
H.Seto


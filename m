Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZL1IEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZL1IEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZL1IEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:04:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51996 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZL1IEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:04:24 -0500
Message-ID: <4B386615.7000207@cn.fujitsu.com>
Date: Mon, 28 Dec 2009 16:02:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH] perf_event: mount debugfs automatically
References: <4B383DE3.3070702@cn.fujitsu.com> <20091228074426.GA20039@elte.hu>
In-Reply-To: <20091228074426.GA20039@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
>> Mount debugfs automatically if it's not mounted, umount it
>> when programme exit
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  tools/perf/perf.c         |   10 +++++++++-
>>  tools/perf/util/debugfs.c |   16 +++++++---------
>>  tools/perf/util/debugfs.h |    2 +-
>>  3 files changed, 17 insertions(+), 11 deletions(-)
> 
> I'm not sure that's a good idea. What happens if two perf tools are running in 
> parallel:
> 
>   perf report #1 start
>                           perf report #2 start
>   perf report #2 exit [umount debugfs]
>                           perf report #2 tries to open /debug file: kaboom
>                           perf report #2 exit
> 

Sorry, i not notice it, it can't work under this case.

> But your idea is sound if we only do the first half: we should mount it under 
> /sys/kernel/debug/ if it's not mounted already [and that directory is 
> available], and leave it mounted there.
> 

Um, i'll rewrite it and just mount it under /sys/kernel/debug

Thanks,
Xiao

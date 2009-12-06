Return-Path: <linux-kernel-owner+w=401wt.eu-S933682AbZLFLFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682AbZLFLFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 06:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933305AbZLFLFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 06:05:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbZLFLFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 06:05:15 -0500
Subject: Re: [PATCH] perf/sched: fix for getting task's execute time
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1B8E0E.3040007@cn.fujitsu.com>
References: <4B1B8E0E.3040007@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Dec 2009 12:05:12 +0100
Message-ID: <1260097512.7818.341.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 18:57 +0800, Xiao Guangrong wrote:
> In current code, we get task's execute time by reading
> "/proc/<pid>/sched" file, it's wrong if the task is created
> by pthread_create(), because every thread task has same pid.
> So, the correct way is reading "/proc/<ppid>/task/<tid>/sched"
> file.
> 
> This patch also remove redundant include files since <sys/types.h>
> is included in "perf.h"

We really should not be using these proc files but instead make sure
this information gets transferred through a tracepoint or similar.

Reading these proc files is too prone to races.



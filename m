Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbZDGVKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbZDGVKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbZDGVJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:09:55 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:51949 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbZDGVJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:09:54 -0400
Date: Tue, 7 Apr 2009 17:04:17 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>, Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/3] cpuset,mm: fix memory spread bug
In-Reply-To: <49DB306A.8070407@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0904071703340.12192@qirst.com>
References: <49DB306A.8070407@cn.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting patch set but I cannot find parts 2 and 3. The locking changes
get rid of the generation scheme in cpusets which is a good thing if it
works right.

On Tue, 7 Apr 2009, Miao Xie wrote:

> The kernel still allocated the page caches on old node after modifying its
> cpuset's mems when 'memory_spread_page' was set, or it didn't spread the page
> cache evenly over all the nodes that faulting task is allowed to usr after
> memory_spread_page was set. it is caused by the old mem_allowed and flags
> of the task, the current kernel doesn't updates them unless some function
> invokes cpuset_update_task_memory_state(), it is too late sometimes.We must
> update the mem_allowed and the flags of the tasks in time.
>
> Slab has the same problem.
>
> The following patches fix this bug by updating tasks' mem_allowed and spread
> flag after its cpuset's mems or spread flag is changed.
>
> patch 1: restructure the function cpuset_update_task_memory_state()
> patch 2: update tasks' page/slab spread flags in time
> patch 3: update tasks' mems_allowed in time
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

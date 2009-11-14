Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZKNJCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZKNJCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 04:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbZKNJCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 04:02:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:38985 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZKNJCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 04:02:12 -0500
Message-ID: <4AFE7200.5040601@kernel.org>
Date: Sat, 14 Nov 2009 18:01:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.32-rc6] workqueue: fix race condition in	schedule_on_each_cpu()
References: <4AFD26F5.809@kernel.org> <20091113153827.GA6475@redhat.com>
In-Reply-To: <20091113153827.GA6475@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

11/14/2009 12:38 AM, Oleg Nesterov wrote:
> A very minor nit, schedule_on_each_cpu() still checks "orig" twice,
> perhaps it makes sense to do
> 
> 	for_each_online_cpu(cpu) {
> 		struct work_struct *work = per_cpu_ptr(works, cpu);
> 
> 		INIT_WORK(work, func);
> 
> 		if (likely(cpu != orig))
> 			schedule_work_on(cpu, work);
> 		else
> 			func(work);
> 	}

The intention was to schedule works on all other cpus first and then
execute it on local cpu so that if it takes some time, it doesn't have
to go through the latency twice.

Thanks.

-- 
tejun

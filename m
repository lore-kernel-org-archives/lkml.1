Return-Path: <linux-kernel-owner+w=401wt.eu-S1751294AbZKNSyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbZKNSyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 13:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZKNSyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 13:54:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZKNSyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 13:54:35 -0500
Date: Sat, 14 Nov 2009 19:49:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.32-rc6] workqueue: fix race condition in
	schedule_on_each_cpu()
Message-ID: <20091114184910.GA3649@redhat.com>
References: <4AFD26F5.809@kernel.org> <20091113153827.GA6475@redhat.com> <4AFE7200.5040601@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFE7200.5040601@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14, Tejun Heo wrote:
>
> 11/14/2009 12:38 AM, Oleg Nesterov wrote:
> > A very minor nit, schedule_on_each_cpu() still checks "orig" twice,
> > perhaps it makes sense to do
> >
> > 	for_each_online_cpu(cpu) {
> > 		struct work_struct *work = per_cpu_ptr(works, cpu);
> >
> > 		INIT_WORK(work, func);
> >
> > 		if (likely(cpu != orig))
> > 			schedule_work_on(cpu, work);
> > 		else
> > 			func(work);
> > 	}
>
> The intention was to schedule works on all other cpus first and then
> execute it on local cpu so that if it takes some time, it doesn't have
> to go through the latency twice.

Ah, indeed, you are right.

Oleg.


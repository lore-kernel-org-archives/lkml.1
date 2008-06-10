Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYFJUzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYFJUzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758430AbYFJUzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:55:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2760 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759345AbYFJUzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:55:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=LQ7IDUagNGxHF/ci3dp6cECy7yNQCHLAFnRK1JmW87mHLOglZupNrd28JhMCQBVHq
	tCbfUay8z8sbBvuWY3h2g==
Date: Tue, 10 Jun 2008 13:54:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Max Krasnyansky <maxk@qualcomm.com>
cc: Paul Jackson <pj@sgi.com>, mingo@elte.hu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: cpusets and kthreads, inconsistent behaviour
In-Reply-To: <484EE7BE.3000606@qualcomm.com>
Message-ID: <alpine.DEB.1.10.0806101350110.29422@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <alpine.DEB.1.10.0806091447300.10680@chino.kir.corp.google.com>
 <484EAC2F.5020103@qualcomm.com> <alpine.DEB.1.10.0806101135050.28953@chino.kir.corp.google.com> <484EE7BE.3000606@qualcomm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Max Krasnyansky wrote:

> Hmm, technically you are correct of course. But we do not have any other
> kernel tasks besides kthreads. All the kernel tasks I have on my machines have
> kthreadd as their parent.
> And I'm not aware of any kernel code that changes affinity mask of a
> user-space task without paying attention to the cpuset the task belongs to. If
> you know of any we should fix it because it'd clearly be a bug.
> 

This is why it shouldn't belong in the sched or kthread code; the 
discrepency that you point out between p->cpus_allowed and 
task_cs(p)->cpus_allowed is a cpuset created one.

So to avoid having tasks with a cpus_allowed mask that is not a subset of 
its cpuset's set of allowable cpus, the solution would probably be to add 
a flavor of cpuset_update_task_memory_state() for a cpus generation value.

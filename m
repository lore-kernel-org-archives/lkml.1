Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbZAEJW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbZAEJW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZAEJWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:22:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZAEJWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:22:17 -0500
Message-ID: <4961D10B.5040106@cn.fujitsu.com>
Date: Mon, 05 Jan 2009 17:21:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] cpuset: convert cpuset_attach() to use cpumask_var_t
References: <495B2EA6.7010808@cn.fujitsu.com>	<495B2EC2.9090305@cn.fujitsu.com>	<495B2EE7.4040406@cn.fujitsu.com>	<495B2EFB.302@cn.fujitsu.com>	<20090104233856.8c72eb58.akpm@linux-foundation.org>	<4961C919.6040404@cn.fujitsu.com>	<20090105010147.bc42b655.akpm@linux-foundation.org>	<4961CD36.7070507@cn.fujitsu.com> <20090105011414.176a5ee3.akpm@linux-foundation.org>
In-Reply-To: <20090105011414.176a5ee3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> OK, that works.
>>>
>>> Do we need to dynamically allocate cpus_attach?  Can we just do
>>>
>>> static cpumask_t cpus_attach;
>>>
>>> ?
>>>
>> Yes, it's used by cpuset_attach() only, and cpuset_attach() is called with
>> cgroup_lock() held, so it won't happen that 2 threads access cpus_attach
>> concurrently.
> 
> You misunderstand my question.  I think.
> 
> Can we allocate cpus_attach at compile time?  Completely, not
> partially.  By doing
> 
> static cpumask_t cpus_attach;
> 
> instead of
> 
> static cpumask_var_t cpus_attach;
> ...
> 	alloc_cpumask_var(&cpus_attach, GFP_KERNEL);
> 
> ?

Ah, I misunderstood. Yes a static cpumask_t works, but what Mike Travis and
Rusty is doing is to remove cpumask_t completely, and replace cpumask_t
with cpumask_var_t wherever possible.


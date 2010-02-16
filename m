Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab0BPXzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:55:01 -0500
Received: from smtp-out.google.com ([216.239.44.51]:57080 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab0BPXzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:55:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=V+jlklQceQAnsnUOGOHUR2ZNMPt4IvkIKh/oZ8dN248TS4EuwFmI1Bmz4BWD/jtXx
	sr3chprThOquiehtbuXZA==
Date: Tue, 16 Feb 2010 15:54:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
In-Reply-To: <20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com> <20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
 <20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com> <20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:

> Please don't. I had a chance to talk with customer support team and talked
> about panic_on_oom briefly. I understood that panic_on_oom_alyways+kdump
> is the strongest tool for investigating customer's OOM situtation and do
> the best advice to them. panic_on_oom_always+kdump is the 100% information
> as snapshot when oom-killer happens. Then, it's easy to investigate and
> explain what is wront. They sometimes discover memory leak (by some prorietary
> driver) or miss-configuration of the system (as using unnecessary bounce buffer.)
> 

Ok, I'm not looking to cause your customers unnecessary grief by removing 
an option that they use, even though the same effect is possible by 
setting all tasks to OOM_DISABLE.  I'll remove this patch in the next 
revision.

> Then, please leave panic_on_oom=always.
> Even with mempolicy or cpuset 's OOM, we need panic_on_oom=always option.
> And yes, I'll add something similar to memcg. freeze_at_oom or something.
> 

Memcg isn't a special case here, it should also panic the machine if 
panic_on_oom == 2, so if we aren't going to remove this option then I 
agree with Nick that we need to panic from mem_cgroup_out_of_memory() as 
well.  Some users use cpusets, for example, for the same effect of memory 
isolation as you use memcg, so panicking in one scenario and not the other 
is inconsistent.

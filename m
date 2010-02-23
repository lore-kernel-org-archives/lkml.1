Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0BWWW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:22:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:7036 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0BWWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:22:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tmF3WR3kxRzX6lca/t9IQUCYT07fMW58vLURZYbneQwnRTTs/GJcKdH29pQBNLXKx
	BlEAIzGrhKmuTyG3HfR0g==
Date: Tue, 23 Feb 2010 14:22:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vivek Goyal <vgoyal@redhat.com>
cc: Andrea Righi <arighi@develer.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: dirty pages instrumentation
In-Reply-To: <20100223195606.GD11930@redhat.com>
Message-ID: <alpine.DEB.2.00.1002231419450.8693@chino.kir.corp.google.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com> <1266765525-30890-3-git-send-email-arighi@develer.com> <20100222165215.GA3096@redhat.com> <20100223094040.GC1882@linux> <20100223195606.GD11930@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Vivek Goyal wrote:

> > > Because you have modified dirtyable_memory() and made it per cgroup, I
> > > think it automatically takes care of the cases of per cgroup dirty ratio,
> > > I mentioned in my previous mail. So we will use system wide dirty ratio
> > > to calculate the allowed dirty pages in this cgroup (dirty_ratio *
> > > available_memory()) and if this cgroup wrote too many pages start
> > > writeout? 
> > 
> > OK, if I've understood well, you're proposing to use per-cgroup
> > dirty_ratio interface and do something like:
> 
> I think we can use system wide dirty_ratio for per cgroup (instead of
> providing configurable dirty_ratio for each cgroup where each memory
> cgroup can have different dirty ratio. Can't think of a use case
> immediately).

I think each memcg should have both dirty_bytes and dirty_ratio, 
dirty_bytes defaults to 0 (disabled) while dirty_ratio is inherited from 
the global vm_dirty_ratio.  Changing vm_dirty_ratio would not change 
memcgs already using their own dirty_ratio, but new memcgs would get the 
new value by default.  The ratio would act over the amount of available 
memory to the cgroup as though it were its own "virtual system" operating 
with a subset of the system's RAM and the same global ratio.

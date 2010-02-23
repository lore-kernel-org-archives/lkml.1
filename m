Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab0BWJz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 04:55:59 -0500
Received: from trinity.develer.com ([83.149.158.210]:48976 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0BWJz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 04:55:58 -0500
Date: Tue, 23 Feb 2010 10:55:55 +0100
From: Andrea Righi <arighi@develer.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/2] memcg: per cgroup dirty limit
Message-ID: <20100223095555.GF1882@linux>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
 <20100222142744.GB13823@redhat.com>
 <20100222181226.GC4052@linux>
 <20100222182934.GD3096@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222182934.GD3096@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 01:29:34PM -0500, Vivek Goyal wrote:
> > I would't like to add many different interfaces to do the same thing.
> > I'd prefer to choose just one interface and always use it. We just have
> > to define which is the best one. IMHO dirty_bytes is more generic. If
> > we want to define the limit as a % we can always do that in userspace.
> > 
> 
> dirty_ratio is easy to configure. One system wide default value works for
> all the newly created cgroups. For dirty_bytes, you shall have to
> configure each and individual cgroup with a specific value depneding on
> what is the upper limit of memory for that cgroup.

OK.

> 
> Secondly, memory cgroup kind of partitions global memory resource per
> cgroup. So if as long as we have global dirty ratio knobs, it makes sense
> to have per cgroup dirty ratio knob also. 
> 
> But I guess we can introduce that later and use gloabl dirty ratio for
> all the memory cgroups (instead of each cgroup having a separate dirty
> ratio). The only thing is that we need to enforce this dirty ratio on the
> cgroup and if I am reading the code correctly, your modifications of
> calculating available_memory() per cgroup should take care of that.

At the moment (with dirty_bytes) if the cgroup has dirty_bytes == 0, it
simply uses the system wide available_memory(), ignoring the memory
upper limit for that cgroup and fallbacks to the current behaviour.

With dirty_ratio, should we change the code to *always* apply this
percentage to the cgroup memory upper limit, and automatically set it
equal to the global dirty_ratio by default when the cgroup is created?
mmmh... I vote yes.

-Andrea

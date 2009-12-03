Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZLCBxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZLCBxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 20:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZLCBxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 20:53:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:60287 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZLCBxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 20:53:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="218200144"
Date: Thu, 3 Dec 2009 09:53:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/24] cgroup: define empty css_put() when
	!CONFIG_CGROUPS
Message-ID: <20091203015339.GC8520@localhost>
References: <20091202031231.735876003@intel.com> <20091202043046.420815285@intel.com> <6599ad830912021448h6f939623y43fbe5fde2c36b85@mail.gmail.com> <20091202225243.GO18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091202225243.GO18989@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 06:52:43AM +0800, Andi Kleen wrote:
> On Wed, Dec 02, 2009 at 02:48:03PM -0800, Paul Menage wrote:
> > On Tue, Dec 1, 2009 at 7:12 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > --- linux-mm.orig/include/linux/cgroup.h        2009-11-02 10:18:41.000000000 +0800
> > > +++ linux-mm/include/linux/cgroup.h     2009-11-02 10:26:22.000000000 +0800
> > > @@ -581,6 +581,9 @@ static inline int cgroupstats_build(stru
> > >        return -EINVAL;
> > >  }
> > >
> > > +struct cgroup_subsys_state;
> > > +static inline void css_put(struct cgroup_subsys_state *css) {}
> > > +
> > >  #endif /* !CONFIG_CGROUPS */
> > 
> > This doesn't sound like the right thing to do - if !CONFIG_CGROUPS,
> > then the code shouldn't be able to see a css structure to pass to this
> > function.
> 
> I agree. The high level code should be ifdefed.

Right. Following your suggestion to ifdef the memcg user
hwpoison_filter_task(), this patch can be dropped.

Thanks,
Fengguang

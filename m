Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZLBWwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZLBWwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZLBWwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:52:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35973 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbZLBWwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:52:40 -0500
Date: Wed, 2 Dec 2009 23:52:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Paul Menage <menage@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/24] cgroup: define empty css_put() when !CONFIG_CGROUPS
Message-ID: <20091202225243.GO18989@one.firstfloor.org>
References: <20091202031231.735876003@intel.com> <20091202043046.420815285@intel.com> <6599ad830912021448h6f939623y43fbe5fde2c36b85@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6599ad830912021448h6f939623y43fbe5fde2c36b85@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 02:48:03PM -0800, Paul Menage wrote:
> On Tue, Dec 1, 2009 at 7:12 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > --- linux-mm.orig/include/linux/cgroup.h        2009-11-02 10:18:41.000000000 +0800
> > +++ linux-mm/include/linux/cgroup.h     2009-11-02 10:26:22.000000000 +0800
> > @@ -581,6 +581,9 @@ static inline int cgroupstats_build(stru
> >        return -EINVAL;
> >  }
> >
> > +struct cgroup_subsys_state;
> > +static inline void css_put(struct cgroup_subsys_state *css) {}
> > +
> >  #endif /* !CONFIG_CGROUPS */
> 
> This doesn't sound like the right thing to do - if !CONFIG_CGROUPS,
> then the code shouldn't be able to see a css structure to pass to this
> function.

I agree. The high level code should be ifdefed.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

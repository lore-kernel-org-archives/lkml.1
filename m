Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab0CLKBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:01:33 -0500
Received: from trinity.develer.com ([83.149.158.210]:38844 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab0CLKBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:01:32 -0500
Date: Fri, 12 Mar 2010 11:01:29 +0100
From: Andrea Righi <arighi@develer.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v6)
Message-ID: <20100312100129.GB4438@linux>
References: <1268175636-4673-1-git-send-email-arighi@develer.com>
 <20100311093913.07c9ca8a.kamezawa.hiroyu@jp.fujitsu.com>
 <20100311101726.f58d24e9.kamezawa.hiroyu@jp.fujitsu.com>
 <1268298865.5279.997.camel@twins>
 <20100311182500.0f3ba994.kamezawa.hiroyu@jp.fujitsu.com>
 <20100311150307.GC29246@redhat.com>
 <20100311232708.GE2427@linux>
 <20100312085244.98e48991.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312085244.98e48991.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 08:52:44AM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 12 Mar 2010 00:27:09 +0100
> Andrea Righi <arighi@develer.com> wrote:
> 
> > On Thu, Mar 11, 2010 at 10:03:07AM -0500, Vivek Goyal wrote:
> 
> > > I am still setting up the system to test whether we see any speedup in
> > > writeout of large files with-in a memory cgroup with small memory limits.
> > > I am assuming that we are expecting a speedup because we will start
> > > writeouts early and background writeouts probably are faster than direct
> > > reclaim?
> > 
> > mmh... speedup? I think with a large file write + reduced dirty limits
> > you'll get a more uniform write-out (more frequent small writes),
> > respect to few and less frequent large writes. The system will be more
> > reactive, but I don't think you'll be able to see a speedup in the large
> > write itself.
> > 
> Ah, sorry. I misunderstood something. But it's depends on dirty_ratio param.
> If
> 	background_dirty_ratio = 5
> 	dirty_ratio	       = 100
> under 100M cgroup, I think background write-out will be a help.

Right, in this case background flusher threads will help a lot to
write-out the cgroup dirty memory and it'll get better performance.

-Andrea

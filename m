Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725Ab0BZASe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:18:34 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46734 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934672Ab0BZASc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:18:32 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Feb 2010 09:14:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <arighi@develer.com>
Cc: David Rientjes <rientjes@google.com>, Vivek Goyal <vgoyal@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: dirty pages instrumentation
Message-Id: <20100226091421.8c15c210.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100225143444.GB3964@linux>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
	<1266765525-30890-3-git-send-email-arighi@develer.com>
	<20100222165215.GA3096@redhat.com>
	<20100223094040.GC1882@linux>
	<20100223195606.GD11930@redhat.com>
	<alpine.DEB.2.00.1002231419450.8693@chino.kir.corp.google.com>
	<20100225143444.GB3964@linux>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010 15:34:44 +0100
Andrea Righi <arighi@develer.com> wrote:

> On Tue, Feb 23, 2010 at 02:22:12PM -0800, David Rientjes wrote:
> > On Tue, 23 Feb 2010, Vivek Goyal wrote:
> > 
> > > > > Because you have modified dirtyable_memory() and made it per cgroup, I
> > > > > think it automatically takes care of the cases of per cgroup dirty ratio,
> > > > > I mentioned in my previous mail. So we will use system wide dirty ratio
> > > > > to calculate the allowed dirty pages in this cgroup (dirty_ratio *
> > > > > available_memory()) and if this cgroup wrote too many pages start
> > > > > writeout? 
> > > > 
> > > > OK, if I've understood well, you're proposing to use per-cgroup
> > > > dirty_ratio interface and do something like:
> > > 
> > > I think we can use system wide dirty_ratio for per cgroup (instead of
> > > providing configurable dirty_ratio for each cgroup where each memory
> > > cgroup can have different dirty ratio. Can't think of a use case
> > > immediately).
> > 
> > I think each memcg should have both dirty_bytes and dirty_ratio, 
> > dirty_bytes defaults to 0 (disabled) while dirty_ratio is inherited from 
> > the global vm_dirty_ratio.  Changing vm_dirty_ratio would not change 
> > memcgs already using their own dirty_ratio, but new memcgs would get the 
> > new value by default.  The ratio would act over the amount of available 
> > memory to the cgroup as though it were its own "virtual system" operating 
> > with a subset of the system's RAM and the same global ratio.
> 
> Agreed.
> 
BTW, please add background_dirty_ratio in the same series of patches.
(or something other to kick background-writeback in proper manner.)

If not, we can't kick background write-back until we're caught by dirty_ratio.

Thanks,
-Kame






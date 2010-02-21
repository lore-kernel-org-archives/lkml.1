Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab0BUWdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:33:13 -0500
Received: from trinity.develer.com ([83.149.158.210]:56474 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0BUWdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:33:12 -0500
Date: Sun, 21 Feb 2010 23:33:06 +0100
From: Andrea Righi <arighi@develer.com>
To: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>, Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: dirty pages instrumentation
Message-ID: <20100221223305.GB5233@linux>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
 <1266765525-30890-3-git-send-email-arighi@develer.com>
 <alpine.DEB.2.00.1002211328530.22858@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002211328530.22858@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 01:38:28PM -0800, David Rientjes wrote:
> On Sun, 21 Feb 2010, Andrea Righi wrote:
> 
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 0b19943..c9ff1cd 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -137,10 +137,11 @@ static struct prop_descriptor vm_dirties;
> >   */
> >  static int calc_period_shift(void)
> >  {
> > -	unsigned long dirty_total;
> > +	unsigned long dirty_total, dirty_bytes;
> >  
> > -	if (vm_dirty_bytes)
> > -		dirty_total = vm_dirty_bytes / PAGE_SIZE;
> > +	dirty_bytes = mem_cgroup_dirty_bytes();
> > +	if (dirty_bytes)
> > +		dirty_total = dirty_bytes / PAGE_SIZE;
> >  	else
> >  		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
> >  				100;
> 
> This needs a comment since mem_cgroup_dirty_bytes() doesn't imply that it 
> is responsible for returning the global vm_dirty_bytes when that's 
> actually what it does (both for CONFIG_CGROUP_MEM_RES_CTRL=n and root 
> cgroup).

Fair enough.

Thanks,
-Andrea

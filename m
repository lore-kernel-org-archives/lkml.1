Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337Ab0AFHP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0AFHP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997Ab0AFHPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:15:25 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56028 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab0AFHPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:15:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 6 Jan 2010 16:12:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-Id: <20100106161211.5a7b600f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100106070150.GL3059@balbir.in.ibm.com>
References: <20091229182743.GB12533@balbir.in.ibm.com>
	<20100104085108.eaa9c867.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104000752.GC16187@balbir.in.ibm.com>
	<20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104005030.GG16187@balbir.in.ibm.com>
	<20100106130258.a918e047.kamezawa.hiroyu@jp.fujitsu.com>
	<20100106070150.GL3059@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 12:31:50 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > No. If it takes long time, locking fork()/exit() for such long time is the bigger
> > issue.
> > I recommend you to add memacct subsystem to sum up RSS of all processes's RSS counting
> > under a cgroup.  Althoght it may add huge costs in page fault path but implementation
> > will be very simple and will not hurt realtime ops.
> > There will be no terrible race, I guess.
> >
> 
> But others hold that lock as well, simple thing like listing tasks and
> moving tasks, etc. I expect the usage of shared to be in the same
> range.
> 

And piles up costs ? I think cgroup guys should pay attention to fork/exit
costs more. Now, it gets slower and slower.
In that point, I never like migrate-at-task-move work in cpuset and memcg.

My 1st objection to this patch is this "shared" doesn't mean "shared between
cgroup" but means "shared between processes".
I think it's of no use and no help to users.

And implementation is 2nd thing.


Thanks,
-Kame


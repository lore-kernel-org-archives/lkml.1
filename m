Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0CAAuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 19:50:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40952 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab0CAAuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 19:50:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 1 Mar 2010 09:47:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrea Righi <arighi@develer.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: dirty pages instrumentation
Message-Id: <20100301094702.ae0fe7fc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100226214811.GB7498@redhat.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
	<1266765525-30890-3-git-send-email-arighi@develer.com>
	<20100223212943.GF11930@redhat.com>
	<20100225151211.GC3964@linux>
	<20100226214811.GB7498@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 16:48:11 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Feb 25, 2010 at 04:12:11PM +0100, Andrea Righi wrote:
> > On Tue, Feb 23, 2010 at 04:29:43PM -0500, Vivek Goyal wrote:
> > > On Sun, Feb 21, 2010 at 04:18:45PM +0100, Andrea Righi wrote:

> Because bdi_thres calculation will be based on per cgroup dirty and
> bdi_nr_reclaimable and bdi_nr_writeback will be system wide, we will be
> doing much more aggressive writeouts.
> 
> But we will not achieve parallel writeback paths so probably will not help IO
> controller a lot.
> 
> Kame-san, is it a problem, with current memory cgroups where writeback is
> not happening that actively, and you run into situation where there are too
> many dirty pages in a cgroup and reclaim can take long time?
> 
Hmm, not same situation to the global memory management, but we have similar.

In memcg, we just count user's page, "hard to reclaim" situation doesn't happen.
But "reclaim is slower than expected" is an usual problem.

When you try 
% dd id=/dev/zero of=./tmpfifle .....
under proper limitation of memcg, you'll find dd is very slow.
We know background writeback helps this situation. We need to kick background
write-back.

Thanks,
-Kame


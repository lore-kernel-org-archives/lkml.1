Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbZIQV1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbZIQV1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZIQV1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:27:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbZIQV1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:27:39 -0400
Subject: Re: kernel panic - not syncing: out of memory and no killable
 processes
From: Eric Paris <eparis@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl
In-Reply-To: <1253221309.5213.350.camel@dhcp231-106.rdu.redhat.com>
References: <1253158603.5213.204.camel@dhcp231-106.rdu.redhat.com>
	 <1253191435.5213.209.camel@dhcp231-106.rdu.redhat.com>
	 <alpine.DEB.1.00.0909171326340.31112@chino.kir.corp.google.com>
	 <1253219756.5213.348.camel@dhcp231-106.rdu.redhat.com>
	 <1253221309.5213.350.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Sep 2009 17:27:19 -0400
Message-Id: <1253222839.5213.355.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 17:01 -0400, Eric Paris wrote:
> On Thu, 2009-09-17 at 16:35 -0400, Eric Paris wrote:
> > On Thu, 2009-09-17 at 13:29 -0700, David Rientjes wrote:
> > > On Thu, 17 Sep 2009, Eric Paris wrote:
> > > 
> > > > the next-20090916 tree still panic's the same way.  As does Linus'
> > > > latest git tree ab86e5765
> > > > 
> > > > I'll try bisecting between v2.6.31 and master if it would give better
> > > > data than trying to bisect between two -next trees, but I'm sorta stuck
> > > > with a machine that won't boot and doesn't tell me much about why.
> > > > 
> > > 
> > 
> > > Try merging the following patch to get more information such as the 
> > > allocation order and gfp_mask.  It will also show the VM size of all 
> > > kthreads and the state of your system memory to deterine whether there's a 
> > > page allocator issue, lowmem_reserve_ratio is too high, etc.
> > 
> > I'll throw it in.
> > 
> > I did another bisect (mainly because the last one gave a commit that
> > obviously seemed bogus and Ingo ask me to)
> > 
> > 3f2aa307c4d26b4ed6509d0a79e8254c9e07e921 is first bad commit
> > commit 3f2aa307c4d26b4ed6509d0a79e8254c9e07e921
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Thu Sep 10 20:34:48 2009 +0200
> > 
> >     sched: Disable NEW_FAIR_SLEEPERS for now
> > 
> > I'm about to try a linus latest kernel with just this one patch
> > reverted.
> 
> Odd, I tried to revert this patch but it still went boom....

Guess I did something wrong lsat time I tried to revert.  I'm now at 5
successful boots with the patch reverted.  Don't ask me how changing
NEW_FAIR_SLEEPERS causes me to run out of Node 0 DMA32 memory.  But it
does....

-Eric


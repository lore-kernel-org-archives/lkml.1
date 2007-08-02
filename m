Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbXHBPTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbXHBPTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbXHBPTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:19:10 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:50935 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbXHBPTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:19:09 -0400
Subject: Re: [PATCH] 2.6.23-rc1-mm1 - fix missing numa_zonelist_order sysctl
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070802094445.6495e25d.kamezawa.hiroyu@jp.fujitsu.com>
References: <1185994972.5059.91.camel@localhost>
	 <20070802094445.6495e25d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 02 Aug 2007 11:07:38 -0400
Message-Id: <1186067258.5040.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 09:44 +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 01 Aug 2007 15:02:51 -0400
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > [But, maybe reordering the zonelists is not such a good idea
> > when ZONE_MOVABLE is populated?]
> > 
> 
> It's case-by-case I think. In zone order with ZONE_MOVABLE case,
> user's page cache will not use ZONE_NORMAL until ZONE_MOVABLE in all node
> is exhausted. This is an expected behavior, I think.
> 
> I think the real problem is the scheme for "How to set zone movable size to
> appropriate value for the system". This needs more study and documentation.
> (but maybe depends on system configuration to some extent.)

Yes.  Having thought about it a bit more, maybe zone order IS what we
want if we desire the remainder of the zone from which is was taken
[ZONE_MOVABLE-1] to be reserved for non-movable kernel use as long as
possible--similar to the dma zone.  I had made the non-movable zone very
large for testing, so that I could create a segment that used all of the
movable zones on all the nodes and then dip into the non-movable/normal
zone.  If I used a more reasonable [much smaller] amount of kernelcore,
the interleave would have worked as "expected".  

Of course, I don't have any idea of what is a "reasonable amount".
Guess I could look at non-movable zone memory usage in a system at
typical or peak load to get an idea.  Anyone have any data in this
regard?

Lee



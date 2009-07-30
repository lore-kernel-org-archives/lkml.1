Return-Path: <linux-kernel-owner+w=401wt.eu-S1750999AbZG3EII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbZG3EII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 00:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbZG3EIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 00:08:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:54176 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZG3EIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 00:08:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,292,1246863600"; 
   d="scan'208";a="170412606"
Date: Thu, 30 Jul 2009 12:08:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Martin Bligh <mbligh@google.com>
Cc: Chad Talbott <ctalbott@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       "sandeen@redhat.com" <sandeen@redhat.com>,
       Michael Davidson <md@google.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
Message-ID: <20090730040803.GA20652@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com> <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com> <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com> <20090729114322.GA9335@localhost> <33307c790907290711s320607b0i79c939104d4c2d61@mail.gmail.com> <20090730010630.GA7326@localhost> <33307c790907291812j40146a96tc2e9c5e097a33615@mail.gmail.com> <20090730015754.GC7326@localhost> <33307c790907291959r47b1bd3ap7cfa06fd5154aaad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790907291959r47b1bd3ap7cfa06fd5154aaad@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 10:59:09AM +0800, Martin Bligh wrote:
> On Wed, Jul 29, 2009 at 6:57 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > On Thu, Jul 30, 2009 at 09:12:26AM +0800, Martin Bligh wrote:
> >> > I agree on the unification of kupdate and sync paths. In fact I had a
> >> > patch for doing this. And I'd recommend to do it in two patches:
> >> > one to fix the congestion case, another to do the code unification.
> >> >
> >> > The sync path don't care whether requeue_io() or redirty_tail() is
> >> > used, because they disregard the time stamps totally - only order of
> >> > inodes matters (ie. starvation), which is same for requeue_io()/redirty_tail().
> >>
> >> But, as I understand it, both paths share the same lists, so we still have
> >> to be consistent?
> >
> > Then let's first unify the code, then fix the congestion case? :)
> 
> OK, I will send it out as separate patches. I am just finishing up the testing
> first.

Note that this is a simple fix that may have suboptimal write performance.
Here is an old reasoning:

        http://lkml.org/lkml/2009/3/28/235

Thanks,
Fengguang

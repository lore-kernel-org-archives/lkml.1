Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbZG3B56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbZG3B56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 21:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZG3B55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 21:57:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:64617 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZG3B54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 21:57:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,291,1246863600"; 
   d="scan'208";a="170381792"
Date: Thu, 30 Jul 2009 09:57:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Martin Bligh <mbligh@google.com>
Cc: Chad Talbott <ctalbott@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       "sandeen@redhat.com" <sandeen@redhat.com>,
       Michael Davidson <md@google.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
Message-ID: <20090730015754.GC7326@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com> <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com> <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com> <20090729114322.GA9335@localhost> <33307c790907290711s320607b0i79c939104d4c2d61@mail.gmail.com> <20090730010630.GA7326@localhost> <33307c790907291812j40146a96tc2e9c5e097a33615@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790907291812j40146a96tc2e9c5e097a33615@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 09:12:26AM +0800, Martin Bligh wrote:
> > I agree on the unification of kupdate and sync paths. In fact I had a
> > patch for doing this. And I'd recommend to do it in two patches:
> > one to fix the congestion case, another to do the code unification.
> >
> > The sync path don't care whether requeue_io() or redirty_tail() is
> > used, because they disregard the time stamps totally - only order of
> > inodes matters (ie. starvation), which is same for requeue_io()/redirty_tail().
> 
> But, as I understand it, both paths share the same lists, so we still have
> to be consistent?

Then let's first unify the code, then fix the congestion case? :)

> Also, you set flags like more_io higher up in sync_sb_inodes() based on
> whether there's anything in s_more_io queue, so it still seems to have
> some effect to me?

Yes, maybe in some rare cases.

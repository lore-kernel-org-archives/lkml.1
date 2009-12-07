Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbZLGCCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbZLGCCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 21:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758360AbZLGCCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 21:02:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:63250 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187AbZLGCCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 21:02:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="219469358"
Date: Mon, 7 Dec 2009 10:02:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alex Chiang <achiang@hp.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Li, Haicheng" <haicheng.li@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC] print symbolic page flag names in bad_page()
Message-ID: <20091207020222.GB7502@localhost>
References: <20091204212606.29258.98531.stgit@bob.kio> <20091206034636.GA7109@localhost> <20091206230016.GA18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206230016.GA18989@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 07:00:16AM +0800, Andi Kleen wrote:
> > So how about this patch?
> 
> I like it. Decoding the flags by hand is always a very unpleasant experience.
> Bonus: dump_page can be called from kgdb too.

Thank you.  And I'd like to elaborate a bit more on the rational.

Making the page-types tool depend on .config is fragile and dangerous.
It would seem to work but silently return wrong results for a newbie
user or a careless hacker.

And it's troublesome even for home made kernels by a kernel developer.

For example, typically I run many kernel trees with different versions and
kconfigs (both of which change frequently) concurrently.  This means I
would have to judge to run "this" page-types or "that" page-types, and
to check if this page-types is uptodate, and if the .config is in sync
with the running kernel image..

An in-kernel dump_page() makes life easier.

Thanks,
Fengguang

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763561AbZEHRTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763561AbZEHRTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 13:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZEHRTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 13:19:13 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:43337 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753323AbZEHRTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 13:19:12 -0400
Date: Fri, 8 May 2009 13:18:55 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Elladan <elladan@eskimo.com>
cc: Rik van Riel <riel@redhat.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class
 citizen
In-Reply-To: <20090508034054.GB1202@eskimo.com>
Message-ID: <alpine.DEB.1.10.0905081312080.15748@qirst.com>
References: <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <alpine.DEB.1.10.0905070935530.24528@qirst.com> <1241705702.11251.156.camel@twins>
 <alpine.DEB.1.10.0905071016410.24528@qirst.com> <1241712000.18617.7.camel@lts-notebook> <alpine.DEB.1.10.0905071231090.10171@qirst.com> <4A03164D.90203@redhat.com> <20090508034054.GB1202@eskimo.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Elladan wrote:

> > Nobody (except you) is proposing that we completely disable
> > the eviction of executable pages.  I believe that your idea
> > could easily lead to a denial of service attack, with a user
> > creating a very large executable file and mmaping it.

The amount of mlockable pages is limited via ulimit. We can already make
the pages unreclaimable through mlock().

> I don't know of any distro that applies default ulimits, so desktops are
> already susceptible to the far more trivial "call malloc a lot" or "fork bomb"
> attacks.  Plus, ulimits don't help, since they only apply per process - you'd
> need a default mem cgroup before this mattered, I think.

The point remains that the proposed patch does not solve the general
problem that we encounter with exec pages of critical components of the
user interface being evicted from memory.

Do we have test data that shows a benefit? The description is minimal. Rik
claimed on IRC that tests have been done. If so then the patch description
should include the tests. Which loads benefit from this patch?

A significant change to the reclaim algorithm also needs to
have a clear description of the effects on reclaim behavior which is also
lacking.

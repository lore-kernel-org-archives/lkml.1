Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZFOE2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZFOE2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbZFOE2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:28:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:14587 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbZFOE2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:28:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,220,1243839600"; 
   d="scan'208";a="154285360"
Date: Mon, 15 Jun 2009 12:27:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
Message-ID: <20090615042753.GA20788@localhost>
References: <20090615024520.786814520@intel.com> <4A35BD7A.9070208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A35BD7A.9070208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 11:18:18AM +0800, Balbir Singh wrote:
> Wu Fengguang wrote:
> > Hi all,
> > 
> > Comments are warmly welcome on the newly introduced uevent code :)
> > 
> > I hope we can reach consensus in this round and then be able to post
> > a final version for .31 inclusion.
> 
> Isn't that too aggressive? .31 is already in the merge window.

Yes, a bit aggressive. This is a new feature that involves complex logics.
However it is basically a no-op when there are no memory errors,
and when memory corruption does occur, it's better to (possibly) panic
in this code than to panic unconditionally in the absence of this
feature (as said by Rik).

So IMHO it's OK for .31 as long as we agree on the user interfaces,
ie. /proc/sys/vm/memory_failure_early_kill and the hwpoison uevent.

It comes a long way through numerous reviews, and I believe all the
important issues and concerns have been addressed. Nick, Rik, Hugh,
Ingo, ... what are your opinions? Is the uevent good enough to meet
your request to "die hard" or "die gracefully" or whatever on memory
failure events?

Thanks,
Fengguang

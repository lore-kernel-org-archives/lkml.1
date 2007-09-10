Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbXIJTZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbXIJTZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985AbXIJTZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:25:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45660 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756114AbXIJTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:25:16 -0400
Date: Mon, 10 Sep 2007 12:25:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Daniel Phillips <phillips@phunq.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
In-Reply-To: <200709050916.04477.phillips@phunq.net>
Message-ID: <Pine.LNX.4.64.0709101220001.24735@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com> <200709050220.53801.phillips@phunq.net>
 <Pine.LNX.4.64.0709050334020.8127@schroedinger.engr.sgi.com>
 <200709050916.04477.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007, Daniel Phillips wrote:

> > Na, that cannot be the case since it only activates when an OOM
> > condition would otherwise result.
> 
> I did not express myself clearly then.  Compared to our current 
> anti-deadlock patch set, you patch set is a regression.  Because 
> without help from some of our other patches, it does deadlock.  
> Obviously, we cannot have that.

Of course boundless allocations from interrupt / reclaim context will 
ultimately crash the system. To fix that you need to stop the networking 
layer from performing these.

> > Given your tests: It looks like we do not need it.
> 
> I do not agree with that line of thinking.  A single test load only 
> provides evidence, not proof.  Your approach is not obviously correct, 
> quite the contrary.  The tested patch set does not help atomic alloc at 
> all, which is clearly a problem we can hit, we just did not hit it this 
> time.

The patch is obviously correct because it provides memory where we used to 
fail.

> > We have a global dirty page limit already. I fully support Peters
> > work on dirty throttling.
> 
> Alas, I communicated exactly the opposite of what I intended.  We do not 
> like the global dirty limit.  It makes the vm complex and fragile, 
> unnecessarily.  We favor an approach that places less reliance on the 
> global dirty limit so that we can remove some of the fragile and hard 
> to support workarounds we have had to implement because of it.

So far our experience has just been the opposite and Peter's other patches 
demonstrate the same. Dirty limits make the VM stable and increase I/O 
performance.





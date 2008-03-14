Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYCNHgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYCNHgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 03:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYCNHfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 03:35:53 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:60080 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbYCNHfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 03:35:52 -0400
Subject: Re: [PATCH 0/2] lockdep vs recursive read locks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0803131124220.17196@blonde.site>
References: <20080312120920.929901000@chello.nl>
	 <Pine.LNX.4.64.0803131124220.17196@blonde.site>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 08:35:44 +0100
Message-Id: <1205480145.8514.260.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-13 at 11:25 +0000, Hugh Dickins wrote:
> On Wed, 12 Mar 2008, Peter Zijlstra wrote:
> > We seemed to have some lockdep trouble wrt recursive read locks. Today Gautham
> > asked me some specific questions about it, which led to these patches.
> > 
> > IIRC Hugh ran into something similar a while back. This hopefully fixes it.
> 
> Hmm, I don't remember that myself: can you jog my memory?

Sadly that is about as far as my memory went: 

  Hugh spotted problem that lockdep missed, involves r/w lock.

> What I do remember is that when I fixed madvise(MADV_REMOVE i.e. holepunch)
> not to hold mmap_sem (at that time down_write but today down_read, though
> would still be bad) across vmtruncate_range which takes i_mutex (contrast
> writing from an unfaulted area that takes i_mutex then down_read mmap_sem),
> Ingo asked me offline if lockdep caught that and it didn't.  Just tried
> again now, with your patches applied, and madvise_remove restored to its
> old misbehaviour, and it looks like lockdep still doesn't catch it
> (but suspect me of pilot error if you find otherwise).

Ah, ok. Yes, the rwsem will not be affected by this change as it was
specific to recursive readers, which is only allowed by rwlock_t.

I'll try to look into the scenario you described. Would be interesting
to figure that out.


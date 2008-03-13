Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYCML1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYCML1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 07:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYCML0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 07:26:53 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:38556 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYCML0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 07:26:52 -0400
Date: Thu, 13 Mar 2008 11:25:28 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 0/2] lockdep vs recursive read locks
In-Reply-To: <20080312120920.929901000@chello.nl>
Message-ID: <Pine.LNX.4.64.0803131124220.17196@blonde.site>
References: <20080312120920.929901000@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Peter Zijlstra wrote:
> We seemed to have some lockdep trouble wrt recursive read locks. Today Gautham
> asked me some specific questions about it, which led to these patches.
> 
> IIRC Hugh ran into something similar a while back. This hopefully fixes it.

Hmm, I don't remember that myself: can you jog my memory?

What I do remember is that when I fixed madvise(MADV_REMOVE i.e. holepunch)
not to hold mmap_sem (at that time down_write but today down_read, though
would still be bad) across vmtruncate_range which takes i_mutex (contrast
writing from an unfaulted area that takes i_mutex then down_read mmap_sem),
Ingo asked me offline if lockdep caught that and it didn't.  Just tried
again now, with your patches applied, and madvise_remove restored to its
old misbehaviour, and it looks like lockdep still doesn't catch it
(but suspect me of pilot error if you find otherwise).

Hugh

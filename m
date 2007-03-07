Return-Path: <linux-kernel-owner+w=401wt.eu-S965089AbXCGITx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089AbXCGITx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030463AbXCGITx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:19:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:36215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965089AbXCGITw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:19:52 -0500
Date: Wed, 7 Mar 2007 09:19:48 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307081948.GA9563@wotan.suse.de>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307070853.GB15877@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 08:08:53AM +0100, Nick Piggin wrote:
> On Tue, Mar 06, 2007 at 10:51:01PM -0800, Andrew Morton wrote:
> 
> > This patch seems to churn things around an awful lot for minimal benefit.
> 
> Well it fixes the whole design of the nonlinear fault path.

If it doesn't look very impressive, it could be because it leaves all
the old crud around for backwards compatibility (the worst offenders
are removed in patch 6/6).

If you look at the patchset as a whole, it removes about 250 lines,
mostly of (non trivial) duplicated code in filemap.c memory.c shmem.c
fremap.c, that is nonlinear pages specific and doesn't get anywhere
near the testing that the linear fault path does.

A minimal fix for nonlinear pages would have required changing all
->populate handlers, which I simply thought was not very productive
considering the testing and coverage issues, and that I was going to
rewrite the nonlinear path anyway.

If you like, you can consider patches 1,2,3 as the fix, and ignore
nonlinear (hey, it doesn't even bother checking truncate_count today!).

Then 4,5,6 is the fault/nonlinear rewrite, take it or leave it. I thought
you would have liked the patches...


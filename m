Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbXI1IHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbXI1IHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbXI1ICc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:02:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757565AbXI1IC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:02:29 -0400
Message-Id: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:00 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/12] various lockdep patches
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The first 3 patches provide a new lockdep check, it verifies we don't hold any
locks when returning to userspace.

	lockdep-sys_exit.patch
	lockdep-i386-sys_exit.patch
	lockdep-x86_64-sys_exit.patch

Could the various arch maintainers that have support for lockdep help out
with placing this hook?

A journal_start annotation:

	jbd-lock.patch

Up until this point stuff should be safe to merge (assuming there are no
objections and bugs.. :-)

The rest of the series annotates lock_page():

  rework lock_page() API:
	trylock_page.patch
	lock_page.patch
	lockdep-page_lock-hooks.patch

  actuall lockdep annotation:
	lockdep-depth.patch
	lockdep-fs-page.patch
	lockdep-page-async.patch
	set_page_mapping.patch
	lockdep-lock_page.patch

Part of that is re-working the lock_page() API a bit. It introduces 
trylock_page(), and removes all the raw *PageLock() usage.

I've compile and boot tested this series on x86_64 (with and without lockdep).
And it completes an LTP run with lockdep enabled.

Andrew, can we start by pusing the lock_page() API rework into -mm?

 [ this series is against -linus, but if you're willing I'll do some 
   patches against -mm ]



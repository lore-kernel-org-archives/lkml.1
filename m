Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbXBJCb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbXBJCb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 21:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXBJCb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 21:31:27 -0500
Received: from mail.suse.de ([195.135.220.2]:52264 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbXBJCb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 21:31:26 -0500
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-Id: <20070210001844.21921.48605.sendpatchset@linux.site>
Subject: [patch 0/3] 2.6.20 fix for PageUptodate memorder problem (try 3)
Date: Sat, 10 Feb 2007 03:31:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I have got rid of SetPageUptodate_nowarn, and removed the atomic op
from SetNewPageUptodate. Made PageUptodate_NoLock only issue the memory
barrier is the page was uptodate (hopefully the compiler can thread the
branch into the caller's branch).

SetNewPageUptodate does not do the S390 page_test_and_clear_dirty, so
I'd like to make sure that's OK.

Rearranged the patch series so we don't have the first patch introducing
a lot of WARN_ONs that are solved in the next two patches (rather, solve
those issues first).

Thanks,
Nick

--
SuSE Labs


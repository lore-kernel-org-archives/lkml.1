Return-Path: <linux-kernel-owner+w=401wt.eu-S1751075AbXBUEtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbXBUEtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 23:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXBUEtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 23:49:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:41418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbXBUEtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 23:49:46 -0500
From: Nick Piggin <npiggin@suse.de>
To: Linux Memory Management <linux-mm@kvack.org>,
       Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-Id: <20070221023656.6306.246.sendpatchset@linux.site>
Subject: [patch 0/6] fault vs truncate/invalidate race fix
Date: Wed, 21 Feb 2007 05:49:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches are based on current git.

These fix the fault vs invalidate and fault vs truncate_range race for
filemap_nopage mappings, plus those and fault vs truncate race for nonlinear
mappings.

These patches fix silent data corruption that we've had several people hitting
in SUSE kernels. Our kernels have similar patches to lock the page over page
fault, and no problem.

I've also got rid of the horrible populate API, and integrated nonlinear pages
properly with the page fault path.

Downside is that this adds one more vector through which the buffered write
deadlock can occur. However this is just a very tiny one (pte being unmapped
for reclaim), compared to all the other ways that deadlock can occur (unmap,
reclaim, truncate, invalidate). I doubt it will be noticable. At any rate, it
is better than data corruption.

I hope these can get merged (at least into -mm) soon.

Thanks,
Nick

--
SuSE Labs


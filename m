Return-Path: <linux-kernel-owner+w=401wt.eu-S935372AbXGZVgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935372AbXGZVgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 17:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764507AbXGZVf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 17:35:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:46735 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763834AbXGZVf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 17:35:56 -0400
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707261758280.370@blonde.wat.veritas.com>
References: <20070724083855.GA858@elte.hu>
	 <20070724015441.8604d85d.akpm@linux-foundation.org>
	 <1185270045.5439.249.camel@localhost.localdomain>
	 <p73abtmt2y7.fsf@bingen.suse.de>
	 <1185312559.5439.276.camel@localhost.localdomain>
	 <1185345850.8197.64.camel@twins> <20070725094605.GA9045@one.firstfloor.org>
	 <1185358093.5439.325.camel@localhost.localdomain>
	 <20070725102608.GB9045@one.firstfloor.org>
	 <1185360414.5439.335.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707261758280.370@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 07:35:15 +1000
Message-Id: <1185485715.5495.127.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 18:11 +0100, Hugh Dickins wrote:
> That will often be the case for anonymous pages, but not for pagecache
> pages.  I had wondered whether to make exit_mmap unmap the stack first
> (rather than text first as usually happens), but seems rather a hack.

Yup and defeated by HIGHMEM ,so I'm back to per-cpu page lists for now
and we'll see how to move to the next step once I've ironed out other
issues such as sparc64/ia64 related bits.

Ben.



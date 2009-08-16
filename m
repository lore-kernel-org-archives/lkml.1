Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZHPKb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZHPKb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 06:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZHPKb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 06:31:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbZHPKb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 06:31:27 -0400
Date: Sun, 16 Aug 2009 12:31:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
Message-ID: <20090816103127.GB8644@wotan.suse.de>
References: <200908141946.n7EJkh7B018160@mail.q-ag.de> <20090815045237.GC19195@wotan.suse.de> <4A86899A.6050502@colorfullife.com> <20090815103820.GC8954@wotan.suse.de> <4A86ABF0.2070207@colorfullife.com> <20090815144908.GA30951@wotan.suse.de> <4A86E30E.8030208@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A86E30E.8030208@colorfullife.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 06:32:14PM +0200, Manfred Spraul wrote:
> It depends. After disabling inlining, including all helper functions 
> that differ:
> 
> My proposal: 301 bytes for update_queue.
> 
> "simple", only negv: 226 bytes
> "simple, negv+zero: 354 bytes
> simple+complex: 526 bytes.
> 
> Thus with only +-1 simple ops, your version uses less icache. If both 
> +-1 and 0 ops are used, your version uses more icache.

Don't forget that in that case, your version is badly suboptimal
due to the algorithmic complexity.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYJMKj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYJMKj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbYJMKjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:39:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51699 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYJMKjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:39:45 -0400
Date: Mon, 13 Oct 2008 12:46:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: o.weihe@deltacomputer.de
Subject: Re: NUMA allocator on Opteron systems does non-local allocation on node0
Message-ID: <20081013104622.GK12131@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Another copy of the reply with linux-kernel added this time]

> In my setup I'm allocating an array of ~7GiB memory size in a
> singlethreaded application.
> Startup: numactl --cpunodebind=X ./app
> For X=1,2,3 it works as expected, all memory is allocated on the local
> node.
> For X=0 I can see the memory beeing allocated on node0 as long as ~3GiB
> are "free" on node0. At this point the kernel starts using memory from
> node1 for the app!

Hmm, that sounds like it doesn't want to use the 4GB DMA zone.

Normally there should be no protection on it, but perhaps something 
broke.

What does cat /proc/sys/owmem_reserve_ratio say?

> 
> For parallel realworld apps I've seen a performance penalty of 30%
> compared to older kernels!

Compared to what older kernels? When did it start?

-Andi

-- 
ak@linux.intel.com

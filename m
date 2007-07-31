Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbXGaJPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbXGaJPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbXGaJPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:15:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:49187 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbXGaJPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:15:35 -0400
From: Andi Kleen <ak@suse.de>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [rfc] balance-on-fork NUMA placement
Date: Tue, 31 Jul 2007 11:14:08 +0200
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
References: <20070731054142.GB11306@wotan.suse.de>
In-Reply-To: <20070731054142.GB11306@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311114.09284.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2007 07:41, Nick Piggin wrote:

> I haven't given this idea testing yet, but I just wanted to get some
> opinions on it first. NUMA placement still isn't ideal (eg. tasks with
> a memory policy will not do any placement, and process migrations of
> course will leave the memory behind...), but it does give a bit more
> chance for the memory controllers and interconnects to get evenly
> loaded.

I didn't think slab honored mempolicies by default? 
At least you seem to need to set special process flags.

> NUMA balance-on-fork code is in a good position to allocate all of a new
> process's memory on a chosen node. However, it really only starts
> allocating on the correct node after the process starts running.
>
> task and thread structures, stack, mm_struct, vmas, page tables etc. are
> all allocated on the parent's node.

The page tables should be only allocated when the process runs; except
for the PGD.

-Andi

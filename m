Return-Path: <linux-kernel-owner+w=401wt.eu-S1761394AbXGYK0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394AbXGYK0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 06:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbXGYK0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 06:26:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44125 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844AbXGYK0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 06:26:13 -0400
Date: Wed, 25 Jul 2007 12:26:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
Message-ID: <20070725102608.GB9045@one.firstfloor.org>
References: <20070724083855.GA858@elte.hu> <20070724015441.8604d85d.akpm@linux-foundation.org> <1185270045.5439.249.camel@localhost.localdomain> <p73abtmt2y7.fsf@bingen.suse.de> <1185312559.5439.276.camel@localhost.localdomain> <1185345850.8197.64.camel@twins> <20070725094605.GA9045@one.firstfloor.org> <1185358093.5439.325.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185358093.5439.325.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Plan is fixed array or 4 or maybe 8 entries (pointers), that shouldn't
> be -too- bad. The code path I'm a bit worried about is

Yep.

> unmap_mapping_ranges() which goes into zapping page tables from deep
> within filesystems.

Your aim is to conserve stack space? 
The worst case has to work without overflow anyways, so using VLAs don't 
help you. Just allocate the largest size you can safely afford.

This is also easier to test; if it is too large it is better when
the overflow triggers always.

They are more useful in user space with larger stacks when you don't 
know the maximum size.

-Andi


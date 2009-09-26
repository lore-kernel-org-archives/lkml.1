Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZIZDth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZIZDth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 23:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZIZDth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 23:49:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42790 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZIZDth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 23:49:37 -0400
Date: Sat, 26 Sep 2009 05:49:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
Message-ID: <20090926034936.GK30185@one.firstfloor.org>
References: <20090926031537.GA10176@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926031537.GA10176@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 11:15:37AM +0800, Wu Fengguang wrote:
> The swap cache and page cache code assume that they 'own' the newly
> allocated page and therefore can disregard the locking rules. However
> now hwpoison can hit any time on any page.
> 
> So use the safer lock_page()/trylock_page(). The main intention is not
> to close such a small time window of memory corruption. But to avoid
> kernel oops that may result from such races, and also avoid raising
> false alerts in hwpoison stress tests.
> 
> This in theory will slightly increase page cache/swap cache overheads,
> however it seems to be too small to be measurable in benchmark.

Thanks. Can you please describe what benchmarks you used?

Acked-by: Andi Kleen <ak@linux.intel.com>
-andi

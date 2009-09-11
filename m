Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbZIKV4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbZIKV4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZIKV4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:56:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55830 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbZIKV4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:56:45 -0400
Date: Fri, 11 Sep 2009 23:56:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH] [14/21] HWPOISON: shmem: call set_page_dirty() with
	locked page
Message-ID: <20090911215647.GF32562@basil.fritz.box>
References: <20090911848.933193846@firstfloor.org> <20090911184843.32078B1757@basil.firstfloor.org> <1252700646.7126.44.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252700646.7126.44.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Will it, from now on, be mandatory to dirty pages under PG_lock, and

Only data pages with mapping.

It's not a strict requirement, but if it's not done then in theory
you could not propagate an error if the page gets an memory error
at exactly the wrong time. It's probably only worth caring if you
expect to have a lot of pages like this.

> does this patch correct the last few such cases that didn't yet do that,
> or does it still leave holes?

I believe in metadata it's still widely there, but hwpoison ignores
those pages anyways.

> 
> Can we document the requirements and or holes to it someplace near
> set_page_dirty()?

Ok I'll add a comment there.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

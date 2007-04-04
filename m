Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbXDDScO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbXDDScO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbXDDSJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:09:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbXDDSJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:09:35 -0400
Message-ID: <4613E9AF.3030802@redhat.com>
Date: Wed, 04 Apr 2007 14:08:47 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hugh@veritas.com>, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com>	<20070403144948.fe8eede6.akpm@linux-foundation.org>	<20070403160231.33aa862d.akpm@linux-foundation.org>	<Pine.LNX.4.64.0704040949050.17341@blonde.wat.veritas.com> <20070404110406.c79b850d.akpm@linux-foundation.org>
In-Reply-To: <20070404110406.c79b850d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> There are other ways of doing it - I guess we could use a new page flag to
> indicate that this is one-of-those-pages, and add new code to handle it in
> all the right places.

That's what I did.  I'm currently working on the
zap_page_range() side of things.

> One thing which we haven't sorted out with all this stuff: once the
> application has marked an address range (and some pages) as
> whatever-were-going-call-this-feature, how does the application undo that
> change? 

It doesn't have to do anything.  Just access the page and the
MMU will mark it dirty/accessed and the VM will not reclaim
it.

> What effect will things like mremap, madvise and mlock have upon
> these pages?

Good point.  I had not thought about these.

Would you mind if I sent an initial proof of concept
patch that does not take these into account, before
we decide on what should happen in these cases? :)

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.

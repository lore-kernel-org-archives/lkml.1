Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZFBN6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZFBN6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZFBN6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:58:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36151 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbZFBN6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:58:37 -0400
Date: Tue, 2 Jun 2009 16:05:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, hugh@veritas.com, riel@redhat.com,
       akpm@linux-foundation.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090602140545.GP1065@one.firstfloor.org>
References: <20090601185147.GT1065@one.firstfloor.org> <20090602121031.GC1392@wotan.suse.de> <20090602123450.GF1065@one.firstfloor.org> <20090602123720.GF1392@wotan.suse.de> <20090602125538.GH1065@one.firstfloor.org> <20090602130306.GA6262@wotan.suse.de> <20090602132002.GJ1065@one.firstfloor.org> <20090602131937.GB6262@wotan.suse.de> <20090602134610.GO1065@one.firstfloor.org> <20090602134739.GA26982@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602134739.GA26982@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I was kind of thinking about we could SIGKILL them as they try
> to access it or fsync it. But then the question is how long to
> keep SIGKILLing? At one end of the scale you could do stupid
> and simple and have another error flag in the mapping to do
> the SIGKILL just once for the next read/write/fsync etc. Or

It's pretty radical to SIGKILL on a IO error.

Perhaps we can make fsync give EIO again in this case 
with a new mapping flag. The question would be when
to clear that flag again. Probably devil in the details.

> at the other end, you keep the page in the pagecache and
> poisoned, and kill everyone until the page is explicitly truncated
> by userspace. I don't really know...

We do that for the swapcache to avoid a similar problem, but
it's more a hack than a good solution.  I think it would be
worse for the page cache, because if you stop the program
then there's no reason to keep that around.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

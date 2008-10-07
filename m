Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbYJGOkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbYJGOkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYJGOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:39:52 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:57129 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbYJGOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:39:51 -0400
Date: Tue, 7 Oct 2008 15:38:44 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andi Kleen <andi@firstfloor.org>
cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC, v2] shmat: introduce flag SHM_MAP_HINT
In-Reply-To: <20081007112631.GH20740@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0810071532280.29910@blonde.site>
References: <20081006192923.GJ3180@one.firstfloor.org>
 <1223362670-5187-1-git-send-email-kirill@shutemov.name>
 <20081007082030.GD20740@one.firstfloor.org> <20081007100854.GA5039@localhost.localdomain>
 <20081007112631.GH20740@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, Andi Kleen wrote:
> > I want say that we shouldn't do this check if shmaddr is a search hint.
> > I'm not sure that check is unneeded if shmadd is the exact address.
> 
> mmap should fail in this case because it does the same check for 
> MAP_FIXED. Obviously it cannot succeed when there is already something
> else there.

I'm not really following this, so forgive me if I'm reading you
out of context, but I think you're wrong on that...

The dangerous feature of mmap MAP_FIXED (why we don't usually use
it except within an address range we've already staked out earlier)
is that it does unmap whatever stands in its way.  See the early
	if (flags & MAP_FIXED)
		return addr;
in arch_get_unmapped_area(), and the do_munmap() in mmap_region().

Hugh

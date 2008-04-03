Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbYDCRUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbYDCRUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYDCRUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:20:34 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:49812 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYDCRUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:20:33 -0400
Message-ID: <47F511BF.8090506@panasas.com>
Date: Thu, 03 Apr 2008 20:19:59 +0300
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [0/3] Improve generic fls64 for 64-bit machines
References: <20080315172913.GA21648@mailshack.com>
In-Reply-To: <20080315172913.GA21648@mailshack.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 15, 2008, 19:29 +0200, Alexander van Heukelum <heukelum@mailshack.com> wrote:
> This series of patches:
> 
> [1/3] adds __fls.h to asm-generic
> [2/3] modifies asm-*/bitops.h for 64-bit archs to implement __fls
> [3/3] modifies asm-generic/fls64.h to make use of __fls

I strongly support this.

I wish we'd also have a consistent naming convention for all
the bitops functions so it will be clearer what data type the
function is working on and is the result 0 or 1 based.

It seems like what we currently have is:

name	type	first bit#
----	----	----------
ffs	int	1
fls	int	1
__ffs	ulong	0
__fls	ulong	0	# in your proposal
ffz	ulong	0
fls64	__u64	1

so it seems like
- ffz is misnamed and is rather confusing.
  Apprently is should be renamed to __ffz.

- (new) ffz(x) can be defined to ffs(~(x))

- It'd be nice to have ffs64, and maybe ffz64.

Benny

> 
> I have compiled i386 and x86_64, and they generate the same code as
> before the change. The changes to the other archs are a best effort.
> Please comment.
> 
> If this patch series is accepted, it will make one tiny bit of
> the x86-unification a tiny bit cleaner. The patches are against
> Linus' current tree.
> 
> Andrew, if no concensus can be reached that this is a bad patch
> series, would you be willing to add this to your tree?
> 
> Greetings,
> 	Alexander
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


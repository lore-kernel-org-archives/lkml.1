Return-Path: <linux-kernel-owner+w=401wt.eu-S1423142AbXBBG3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423142AbXBBG3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 01:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423139AbXBBG3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 01:29:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:56189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423142AbXBBG3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 01:29:37 -0500
From: Neil Brown <neilb@suse.de>
To: Nick Piggin <npiggin@suse.de>
Date: Fri, 2 Feb 2007 17:29:06 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17858.55858.642522.861130@notabene.brown>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] mm: half-fix page tail zeroing on write problem
In-Reply-To: message from Nick Piggin on Friday February 2
References: <20070202055142.GA5004@wotan.suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday February 2, npiggin@suse.de wrote:
> Hi,
> 
> For no important reason, I've again looked at those zeroing patches that
> Neil did a while back. I've always thought that a simple
> `write(fd, NULL, size)` would cause the same sorts of problems.

Yeh, but who in their right mind would do that???
Oh, you did :-)

> 
> Turns out it does. If you first write all 1s into a page, then do the
> `write(fd, NULL, size)` at the same position, you end up with all 0s in
> the page (test-case available on request).  Incredible; surely this
> violates the spec?

Does it?
I guess filling with zeros isn't what one would expect, but you could
make a case for it being right.
  write(fd, 0, size)
writes 'size' 0s.  Cool.   Ok, bad-cool.

> 
> The buffered-write fixes I've got actually fix this properly, but  they
> don't look like getting merged any time soon. We could do this simple
> patch which just reduces the chance of corruption from a certainty down
> to a small race.
> 
> Any thoughts?

I cannot see why you make a change to fault_in_pages_writeable.  Is it
just for symmetry?
For the rest, it certainly makes sense to return an early -EFAULT if
you cannot fault in the page.

NeilBrown

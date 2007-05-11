Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbXEKHxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbXEKHxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbXEKHxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:53:31 -0400
Received: from holomorphy.com ([66.93.40.71]:51027 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbXEKHxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:53:31 -0400
Date: Fri, 11 May 2007 00:54:10 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-ID: <20070511075410.GT19966@holomorphy.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com> <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com> <20070511082930.GP2012@bingen.suse.de> <20070511004200.6d30152e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511004200.6d30152e.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At some point in the past, Hugh Dickins wrote:
>>> I'm guessing (haven't rechecked source) that the cpu_idle() call comes
>>> about because the top level pgd of a process gets freed very late in
>>> its exit, and after a great flurry of processes have just exited,
>>> perhaps there was nothing to free up the accumulation.  Though
>>> it still strikes me as an odd place to do it.

On Fri, 11 May 2007 10:29:30 +0200 Andi Kleen <ak@suse.de> wrote:
>> I always found it odd and probably the wrong place too.

On Fri, May 11, 2007 at 12:42:00AM -0700, Andrew Morton wrote:
> so... what's the bottom line here, guys?  Should we change that patch?

My summary:
(1) The patch is safe-as is, though it should move its hook elsewhere.
(2) Scribbling on the memory still irks me but is safe.
(3) I should redo the i386 pgd updates to suck less.
(4) Christoph might let me change quicklists to use struct page pointers.

For (3) I can post the update any time; it won't conflict with the
quicklist code, apart from textually, and I can handle the mergework.
The case one should hold off on merging the quicklist code is if
Christoph wants to update the core quicklist code or have me update
it according to the cached precomputed value scheme I outlined in a
prior post before its initial merge. I'll prepare all the patches for
comment regardless.


-- wli

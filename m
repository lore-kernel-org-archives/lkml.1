Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0BBGoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:44:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:41866 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab0BBGoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:44:13 -0500
Date: Tue, 2 Feb 2010 17:44:09 +1100
From: Nick Piggin <npiggin@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, lwoodman@redhat.com,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, aarcange@redhat.com
Subject: Re: [PATCH -mm] remove VM_LOCK_RMAP code
Message-ID: <20100202064409.GC6175@laptop>
References: <20100128002000.2bf5e365@annuminas.surriel.com>
 <20100129151423.8b71b88e.akpm@linux-foundation.org>
 <20100129193410.7ce915d0@annuminas.surriel.com>
 <20100201061532.GC9085@laptop>
 <4B66F977.5010708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B66F977.5010708@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 10:55:35AM -0500, Rik van Riel wrote:
> On 02/01/2010 01:15 AM, Nick Piggin wrote:
> >On Fri, Jan 29, 2010 at 07:34:10PM -0500, Rik van Riel wrote:
> >>When a VMA is in an inconsistent state during setup or teardown, the
> >>worst that can happen is that the rmap code will not be able to find
> >>the page.
> >
> >OK, but you missed the interesting thing, which is to explain why
> >that worst case is not a problem.
> >
> >rmap of course is not just used for reclaim but also invalidations
> >from mappings, and those guys definitely need to know that all
> >page table entries have been handled by the time they return.
> 
> This is not a problem, because the mapping is in the process
> of being torn down (PTEs just got invalidated by munmap), or
> set up (no PTEs have been instantiated yet).
> 
> The third case is split_vma, where we can have one VMA in an
> inconsistent state (rmap cannot find the PTEs), while the
> other VMA is still in its original state (rmap finds the PTEs
> through that VMA).
> 
> That is what makes this safe.

OK, that sounds fine then. Your changelog was just a bit strange
because you said it would not be able to find the page, which
didn't really make sense.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbZEUSoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbZEUSoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 14:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZEUSoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 14:44:22 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:58959 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbZEUSoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 14:44:21 -0400
Date: Thu, 21 May 2009 11:43:42 -0700
From: "Larry H." <research@subreption.com>
To: Robin Holt <holt@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090521184342.GI10756@oblivion.subreption.com>
References: <20090520183045.GB10547@oblivion.subreption.com> <1242852158.6582.231.camel@laptop> <20090520212413.GF10756@oblivion.subreption.com> <20090521152140.GB29447@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521152140.GB29447@sgi.com>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:21 Thu 21 May     , Robin Holt wrote:
> I agree with the earlier.  If you know enough to set the flag, then
> you know enough to call a function which does a clear before free.
> Does seem like a waste of a page flag.

Again, place of allocation doesn't necessarily equal place of freeing,
and it's most normally never the same location. And those calls are
unnecessary code duplication and overhead which is suboptimal.

Would you also be willing to oversee the job of watching where these
calls will require placement, who uses them and how? The design decision
of forcing people to write extra code for clearing seems wasteful if you
can simply tell them to use a flag, which brings the same benefits at no
extra cost. Plus any future benefits if it's developed further more.

> That sounds like either a thread group flag or a VMA flag, not a page
> flag.  If you make it a page flag, you would still need to track it
> on the vma or process to handle the event where the page gets migrated
> or swapped out.  Really doesn't feel like a page flag is right, but I
> reserve the right to be wrong.

The patch adds a GFP flag and a slab flag for lookaside caches, both
tied to the lower level page flag. I've implemented a task flag for the
process sensitive marking but that one was kept out of the patchset to
keep it simple for now, and as clean and sane as possible. You are right
that this needs to be tracked down in other interfaces to avoid memory
from being swapped to disk, but I didn't want to include this in the
current patchset until I had positive feedback. Either way, those
changes are trivial.

Also, how would you track what memory is sensitive and what isn't? The
clearing only solves one of the issues here. Deterring data resilience
is far more than just zeroing a buffer.

I would like to request inclusion unless more substantial problems are
found with this patchset.

	Larry

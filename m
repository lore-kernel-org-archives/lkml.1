Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbXE1Nxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbXE1Nxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbXE1NxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:53:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51858 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXE1NxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:53:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
	<465A55E7.50904@yahoo.com.au>
	<m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
	<465A6078.6010804@yahoo.com.au>
Date: Mon, 28 May 2007 07:52:35 -0600
In-Reply-To: <465A6078.6010804@yahoo.com.au> (Nick Piggin's message of "Mon,
	28 May 2007 14:54:16 +1000")
Message-ID: <m14plx9hss.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Eric W. Biederman wrote:
>> Nick Piggin <nickpiggin@yahoo.com.au> writes:
>
>>>I would have thought we can fix this simply by removing the
>>>broken ramdisk_set_page_dirty (as far as the comment goes, we
>>>set CAP_NO_ACCT_DIRTY anyway, so the normal set_page_dirty
>>>should handle everything properly, no?).
>>
>>
>> No.  I don't know where accounting comes into play.  I didn't
>> trace that path.  But if we have a non-dirty ramdisk page with
>> buffers (basically a hole in the middle or at the end of the ramdisk).
>> We need to set the buffer dirty bits when we write to it.
>
> Accounting is done in set_page_dirty.

Yes.  What I meant was I had not looked at the implications of
accounting, so I had not looked to see if I could use a generic
set_dirty_page.

I only got as far as recognizing that __set_page_dirty_no_writeback as
not the appropriate function to use because we need to handle buffer
heads.

>> So I don't see how it would make sense to reuse the generic
>> set_page_dirty, and handling all of the logic in set_page_dirty
>> to dirty the buffer heads seemed to have made the most sense.
>
> That's what the generic set_page_dirty does. What I want to know
> is why *doesn't* it make sense to reuse the generic set_page_dirty?
> Unless there is a good reason, then reusing is better than writing
> your own.

I did not look at that part in detail.  I only realized
ramdisk_set_dirty_page needed to be modified upon a final review of my
code, as it was not a case I actually hit.

Just skimming through it again quickly I don't see a reason at this
point to preserve a separate set_dirty_page for the ramdisk code.

Eric

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbXEaL5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbXEaL5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 07:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759380AbXEaL51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 07:57:27 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50087 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255AbXEaL50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 07:57:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
	<465A55E7.50904@yahoo.com.au>
	<m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
	<465A6078.6010804@yahoo.com.au> <465A6197.5010402@yahoo.com.au>
	<m1veed82mz.fsf@ebiederm.dsl.xmission.com>
	<465BB6C2.7050704@yahoo.com.au>
Date: Thu, 31 May 2007 05:56:33 -0600
In-Reply-To: <465BB6C2.7050704@yahoo.com.au> (Nick Piggin's message of "Tue,
	29 May 2007 15:14:42 +1000")
Message-ID: <m164695hqm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Eric W. Biederman wrote:
>> Nick Piggin <nickpiggin@yahoo.com.au> writes:
>
>>> However we
>>>could still set_page_dirty of a block device page without buffers
>>>via an mmap.
>>
>>
>> After the page is made dirty via mmap we have:
>> sys_write -> ... -> block_prepare_write -> ... -> create_empty_buffers.
>
> Yep, that's what I mean.

Actually I just took a second look.  That path is fine because
create_empty_buffers already performs the page dirty check.

>> I suspect that is a pretty rare case but it does indeed seem to exist
>> as a problem.
>
> I think so too. But either we have some misunderstanding of the
> codepaths involved, or the author of the comments there didn't
> consider this case, so...

Do someone needs to stand up and write the additional patches.
Do we have a maintainer for fs/buffer.c?

Eric

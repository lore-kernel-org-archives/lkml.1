Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbXEDOOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbXEDOOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbXEDOOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:14:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43054 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbXEDOOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:14:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure for paravirtualization"
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
	<1178280770.23670.61.camel@localhost.localdomain>
Date: Fri, 04 May 2007 08:13:03 -0600
In-Reply-To: <1178280770.23670.61.camel@localhost.localdomain> (Rusty
	Russell's message of "Fri, 04 May 2007 22:12:50 +1000")
Message-ID: <m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> On Fri, 2007-05-04 at 05:56 -0600, Eric W. Biederman wrote:
>> This reverts commit c9ccf30d77f04064fe5436027ab9d2230c7cdd94.
>> 
>> Entering the kernel at startup_32 without passing our real mode data
>> in %esi, and without guaranteeing that physical and virtual addresses
>> are identity mapped makes head.S impossible to maintain.
>
> Your assertion that these #ifdef-contained lines of code are "impossible
> to maintain" is theatrical.  I'd prefer to wait until we actually have a
> replacement before we go ripping out working code.  

It's not theatrical.  It makes this code path extremely brittle and
very hard to change, which over the long term means that it is
impossible to maintain.  Quickly resulting in a state where any little
change will break something.  See Jeremy's impossible attempt to
detect if we start with physical addresses identity mapped or physical
address mapped at PAGE_OFFSET, just so he can clear the bss before we
test to see if we are running in para-virtualized environment.

The first step in making things better is removing this code (even in
your patches) so this patch doesn't get in the way.

We don't have any working code, there are no in tree users.

Therefore the code should go.

Eric

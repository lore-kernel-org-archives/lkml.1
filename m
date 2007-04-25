Return-Path: <linux-kernel-owner+w=401wt.eu-S1423374AbXDYSYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423374AbXDYSYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423372AbXDYSYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:24:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49430 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992883AbXDYSYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:24:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>
	<20070425044813.f83dde4e.akpm@linux-foundation.org>
	<462F73A0.40003@zytor.com> <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>
	<462F9665.1090602@zytor.com>
Date: Wed, 25 Apr 2007 12:23:18 -0600
In-Reply-To: <462F9665.1090602@zytor.com> (H. Peter Anvin's message of "Wed,
	25 Apr 2007 10:56:53 -0700")
Message-ID: <m1ejm8s489.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>> This patch only affects the initial page tables, which should have been
>>> thrown out *way* long ago at this point.
>> 
>> Yes.  I noticed this was happening a few days ago.
>> I must not have mentioned it loudly enough.
>
> You mentioned the continued use of init_mm.  This is *very* different.
>
> What we're seeing here is that ON PSE-CAPABLE HARDWARE, we continue to
> not just use the init_mm page directory, but the actual page *tables*,
> which should all have been replaced with PSE large pages to begin with.

That is what I meant if not what I communicated.  If you read the code that
is exactly what it is trying to do.

> Reusing the initial page tables on non-PSE-capable hardware *sort of*
> makes sense, but his hardware should not fall in that category, I don't
> think?  (Unless it's one of these machines that fall over if you map the
> bottom 4 MB with PSE pages?)

I agree that I don't think the current behaviour makes sense.  I think
the code has accumulated so many small modifications that is very far
from making sense in the corner cases.

arch/i386 either needs to be frozen as a legacy only thing or
it needs to be cleaned up so we can continue to enhance the code.

Eric

Return-Path: <linux-kernel-owner+w=401wt.eu-S1031368AbXEDQ6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031368AbXEDQ6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031393AbXEDQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:58:50 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40406 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031368AbXEDQ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:58:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>
	<1178283724.23670.70.camel@localhost.localdomain>
	<1178284052.23670.75.camel@localhost.localdomain>
	<m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <463B4E12.50703@goop.org>
	<463B551E.8030701@zytor.com> <463B5B90.20308@goop.org>
Date: Fri, 04 May 2007 10:57:14 -0600
In-Reply-To: <463B5B90.20308@goop.org> (Jeremy Fitzhardinge's message of "Fri,
	04 May 2007 09:13:04 -0700")
Message-ID: <m1irb8r0gl.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> H. Peter Anvin wrote:
>> In 32-bit mode?  Surely you're joking, Mr. Feynman!
>>   
>
> Right, yes.
>
>> What's worse, reloading segments here might be highly unsafe, if the
>> memory previously occupied by the GDT has been overwritten.  Keep in
>> mind the GDT is touched on a segment *load*, not on a segment *access*;
>> in areas such as booting that can be a huge difference.
>>   
>
> Yep, suits me.  I'm happy for the code to assume that at least %cs and
> %ds are sane; I guess %ss too.  We could copy %ds into %[efg]s if we
> want to be sure (since I could imagine a bootloader leaving them in a
> less defined state).
>
> But if the gdt could be missing altogether, then, yes, we should not
> touch them at all.

Peter has a good point here.  We have been reloading segments historically
so the existing boot loaders won't fall over.  If we could load the gdt
in the paravirt solutions all would be simple.

We have real mystery historical cases in Gujin and ELILO.  So it
probably makes sense at this point to force a gdt reload if we can and
otherwise require all of the segments %ds, %es, %fs, %gs to be loaded
with a valid segment, that we can reach everything we need to touch
from.

Eric

Return-Path: <linux-kernel-owner+w=401wt.eu-S1423070AbXEDTXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423070AbXEDTXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423066AbXEDTXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:23:06 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43028 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423078AbXEDTXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:23:04 -0400
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
	<m1irb8r0gl.fsf@ebiederm.dsl.xmission.com>
	<463B683C.5090308@zytor.com>
	<m16478qyxx.fsf@ebiederm.dsl.xmission.com> <463B79E6.8000908@goop.org>
	<m1odl0pgrb.fsf@ebiederm.dsl.xmission.com> <463B8193.3010101@goop.org>
Date: Fri, 04 May 2007 13:21:44 -0600
In-Reply-To: <463B8193.3010101@goop.org> (Jeremy Fitzhardinge's message of
	"Fri, 04 May 2007 11:55:15 -0700")
Message-ID: <m18xc4pf7b.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Well, a paravirtualized ring0 kernel may still have special constraints
> on how the gdt can be set up (page-aligned, read-only, etc).

Maybe but that is hardly ring0.  I would have expected a
para-virtualized ring0 to behave like vmi.  Where everything
works like native hardware until you enable paravirtualization.

> Why not just treat them all in the same way?  Especially if we start
> sweeping other non-virtual architectures like voyager/visws/etc into the
> same mechanism.

That is my intention.  But there are different places we care for
different subarchitectures.  So I'm not convinced an early lookup
table is actually helpful.

The issues are that the kernel provides the version to the boot
loader not the other way around.

The code is simple enough in assembly we don't need a table a table
lookup just:

cmp $MY_PLATFORM, BOOT_PARAMS_PLATFORM(%esi)
jz  my_init.

Roughly this is what rusty has been prototyping in his lguest patches.

> My idea was that "goto native_boot" would jump to code which assumes
> it's running on real hardware, where there's no problem reloading
> gdt/segment registers, etc.

That may make sense to.  It is a question of can we place any code
before the test like clearing the bss?

If we declare the segments are properly initialized it doesn't matter.

Eric

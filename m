Return-Path: <linux-kernel-owner+w=401wt.eu-S1752365AbXBEJhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbXBEJhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 04:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXBEJhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 04:37:31 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54224 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbXBEJha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 04:37:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d?= =?iso-8859-1?Q?=E9ric?= Riss 
	<frederic.riss@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>, Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.20-rc7: known regressions
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	<1170594788.5217.4.camel@funkylaptop>
	<Pine.LNX.4.64.0702040928330.8424@woody.linux-foundation.org>
	<200702050926.51007.ak@suse.de>
Date: Mon, 05 Feb 2007 02:35:32 -0700
In-Reply-To: <200702050926.51007.ak@suse.de> (Andi Kleen's message of "Mon, 5
	Feb 2007 09:26:50 +0100")
Message-ID: <m1k5yxx7yz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> On Sunday 04 February 2007 18:34, Linus Torvalds wrote:
>> 
>> On Sun, 4 Feb 2007, Frédéric Riss wrote:
>> > 
>> > New patch:
>> 
>> I didn't get how this would fix the ia64 issues? I thought ia64 needed 
>> the standard calling convention?
>
> asmlinkage is standard enough on ia64 as far as I can see.
>
> It defines to an undocumented attribute that seems to only affect the
> generated code for functions (basically it forces the compiler
> to not reuse input arguments, similar to prevent_tail_call() on i386), 
> not for pointers.

Regardless.  If we are serious about supporting EFI instead of just
nursing it along for the rare person stuck with it, we are going
to need to remove the brain-dead relocate exactly once to virtual addresses
call, so we can use kexec.

Therefore we will need a trampoline to switch to physical mode.

Of course that presumes the Open (but no one is allowed to read or implement
the standard, or join the committee ) EFI is sufficiently interesting at
some point to bother supporting properly.

Eric

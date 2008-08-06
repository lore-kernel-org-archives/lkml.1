Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbYHFDIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbYHFDIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYHFDIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:08:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48182 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbYHFDIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:08:23 -0400
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: jmerkey@wolfmountaingroup.com, "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: Andi Kleen <andi@firstfloor.org>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
	<Pine.LNX.4.64.0808051140150.6309@anakin>
	<33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>
	<200808060133.10457.nickpiggin@yahoo.com.au>
Date: Wed, 06 Aug 2008 05:08:20 +0200
In-Reply-To: <200808060133.10457.nickpiggin@yahoo.com.au> (Nick Piggin's message of "Wed, 6 Aug 2008 01:33:10 +1000")
Message-ID: <87r6926dsr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:
>
> Seriously? Because it doesn't seem to have had enough peer review,
> it hasn't had widespread testing in somewhere like linux-next or
> -mm, and we already have kgdb so you have to also explain why you
> can't improve kgdb in the areas it trails mdb.
>
> But the ideal outcome would be if you could contribute patches to
> kgdb to the point where it is as good as mdb. It is already in the

I don't think kgdb and a simple assembler debugger 
are directly comparable. kgdb always requires a remote machine,
which has many advantages, but is also often very inconvenient
or impossible to arrange. An low overhead assembler debugger
can be always compiled in just in case.

Also at least for the x86 port the debugger interfaces should
be general enough now (see die hooks as a "debug vfs") that it would
be quite possible to have a multitude of debuggers just using 
them. In fact that's already the cases, kprobes and kgdb and 
kdump are all kinds of debuggers using such hooks.

As long as it doesn't impact the core code and the mdb 
code itself is considered merge worthy and has clean interfaces 
that would seem fine to me.It essentially would just live somewhere in 
its own directory using the existing interfaces. My standard
test for seeing if a debugger has clean interfaces is to see
if it can be loaded as a module.

There are enough different debugging styles around that offering
developers different tools of which they can pick whatever suits
them is not a bad idea. Also as everyone knows debugging
is often a major time eater and if more tools are available that 
can only help the kernel.

That said I haven't read the mdb code, not judging on its general
merge-worthiness or am really completely sure what are all the details
of a "netware style debugger", just a general high level comment on
debuggers. At least judging based on the patch sizes it at least
doesn't seem particularly bloated.  But of course it would need full
proper review first.

-Andi

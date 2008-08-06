Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbYHFRWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbYHFRWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbYHFRW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:22:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:61914 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbYHFRW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:22:26 -0400
Message-ID: <4899DD9F.6020007@windriver.com>
Date: Wed, 06 Aug 2008 12:21:35 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, jmerkey@wolfmountaingroup.com
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>	<Pine.LNX.4.64.0808051140150.6309@anakin>	<33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>	<200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org>
In-Reply-To: <87r6926dsr.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2008 17:21:36.0740 (UTC) FILETIME=[E179FA40:01C8F7E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
>> Seriously? Because it doesn't seem to have had enough peer review,
>> it hasn't had widespread testing in somewhere like linux-next or
>> -mm, and we already have kgdb so you have to also explain why you
>> can't improve kgdb in the areas it trails mdb.
>>
>> But the ideal outcome would be if you could contribute patches to
>> kgdb to the point where it is as good as mdb. It is already in the
>
> I don't think kgdb and a simple assembler debugger
> are directly comparable. kgdb always requires a remote machine,
> which has many advantages, but is also often very inconvenient
> or impossible to arrange. An low overhead assembler debugger
> can be always compiled in just in case.
>

It depends how you look at the problem.  I would agree that the use of
gdb + kgdb vs an assembly debugger are completely different cases.
The kgdb core in the mainline kernel, can actually allow to write such
a front end however.  The kgdb core has an API for I/O and it is
possible to write an I/O module that implements an in kernel assembly
debugger.  The kgdb test suite is not a great example, but it is a
complete example of using the kgdb core directly without a second
machine.

If there is truly missing functionality from kgdb in terms of the way
the kgdb core is used vs mdb, it would be good to at least consider
what is missing.  It is entirely possible to add functionality such
that mdb could be implemented a kgdb I/O module.  In this case you
would be able to make use of zero runtime impact when a kgdb I/O
module is not configure or make use of it as an early/late/ondemand
debugger.

> Also at least for the x86 port the debugger interfaces should
> be general enough now (see die hooks as a "debug vfs") that it would
> be quite possible to have a multitude of debuggers just using
> them. In fact that's already the cases, kprobes and kgdb and
> kdump are all kinds of debuggers using such hooks.
>

I would agree that the possibility exists to use the hooks directly,
and clearly the mdb code base as it stands in this patch set does not
accomplish this.

If one were to consider integrating mdb as a kgdb I/O module, it would
have a greater degree of platform independence.  The primary arch
dependencies should be narrowed down to the back tracing / disassembly
interface. The SMP / threading / breakpoints / exception handling,
would all be shared between the debugger front ends that way.  The mdb
code base currently relies on re-implementing HW/SW breakpoints for
each architecture you desire to support.

Unifying some of the debugging technology is a noble goal where it
makes sense to do so.  Using some of the existing kernel hook points
is a first pass requirement before a merge of mdb could be considered
for the mainline kernel.

Jason.





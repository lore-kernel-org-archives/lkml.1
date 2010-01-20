Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500Ab0ATSbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0ATSbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142Ab0ATSbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:31:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46861 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab0ATSbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:31:46 -0500
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Andi Kleen <andi@firstfloor.org>
References: <1263740593.557.20967.camel@twins>
	<1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>
	<1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>
	<1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>
	<84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
	<4B545146.3080001@redhat.com>
	<20100118124419.GC1628@linux.vnet.ibm.com>
	<84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
	<4B5459CA.9060603@redhat.com> <4B545ACF.40203@cs.helsinki.fi>
	<1263852957.2266.38.camel@localhost.localdomain>
	<4B556855.6040800@redhat.com>
	<1263923265.4998.28.camel@localhost.localdomain>
Date: Wed, 20 Jan 2010 19:31:43 +0100
In-Reply-To: <1263923265.4998.28.camel@localhost.localdomain> (Jim Keniston's message of "Tue, 19 Jan 2010 09:47:45 -0800")
Message-ID: <87wrzc39ww.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Keniston <jkenisto@us.ibm.com> writes:
>
> I don't know of any such plans, but I'd be interested to read more of
> your thoughts here.  As I understand it, you've suggested replacing the
> probed instruction with a jump into an instrumentation vma (the XOL
> area, or something similar).  Masami has demonstrated -- through his
> djprobes enhancement to kprobes -- that this can be done for many x86
> instructions.

The big problem when doing this in user space is that for 64bit
it has to be within 2GB of the probed code, otherwise you would
need to rewrite the instruction to not use any rip relative addressing,
which can be rather complicated (needs registers, but the instruction
might already use them, so you would need a register allocator/spilling etc.)

And that 2GB can be anywhere in the address space for shared
libraries, which might well be already used. A lot of programs
need large VM areas without holes.

Also I personally would be unconfortable to let the instruction
decoder be used by unpriviledged code. Who knows how
many buffer overflows it has?

In general the trend has been also to make traps faster in the CPU, make 
sure you're not optimizing for some old CPU here.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

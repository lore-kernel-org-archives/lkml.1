Return-Path: <linux-kernel-owner+w=401wt.eu-S1763791AbXLOP71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763791AbXLOP71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 10:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbXLOP7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 10:59:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbXLOP7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 10:59:18 -0500
To: eranian@hpl.hp.com
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, paulus@samba.org,
       akpm@linux-foundation.org, gregkh@suse.de, mucci@cs.utk.edu,
       wcohen@redhat.com, robert.richter@amd.com, andi@firstfloor.org,
       eranian@gmail.com, roland@redhat.com
Subject: Re: [perfmon2] perfmon2 merge news
References: <20071119.050843.48408777.davem@davemloft.net>
	<18242.900.101842.261763@cargo.ozlabs.ibm.com>
	<20071119224845.GA27766@frankl.hpl.hp.com>
	<20071119.165313.163834190.davem@davemloft.net>
	<20071213160004.GC6740@frankl.hpl.hp.com>
	<y0mzlwdum3y.fsf@ton.toronto.redhat.com>
	<20071214210709.GE9577@frankl.hpl.hp.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 15 Dec 2007 10:54:41 -0500
In-Reply-To: <20071214210709.GE9577@frankl.hpl.hp.com> (Stephane Eranian's message of "Fri, 14 Dec 2007 13:07:09 -0800")
Message-ID: <y0mbq8s0x8e.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@hpl.hp.com> writes:

> [...]
>> > [...]  AFAIK, there is no single call to stop T1 and wait until it
>> > is completely off the CPU, unless we go through the (internal)
>> > ptrace interface.
>> 
>> The utrace code supports this style of thread manipulation better
>> than ptrace.
>
> Afre you saying that utrace provides a utrace_thread_stop(tid) call
> that returns only when the thread tid is off the CPU. And then there
> is a utrace_thread_resume(tid) call. If that's the case then that is
> what I need.

While I see no single call, it can be synthesized from a sequence of
them: utrace_attach, utrace_set_flags (... UTRACE_ACTION_QUESCE ...),
then waiting for a callback.  Roland, is there a more compact way?

> How are we with regards to utrace integration?

Roland McGrath is working on breaking the patches down.

- FChE

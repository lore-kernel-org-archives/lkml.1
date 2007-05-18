Return-Path: <linux-kernel-owner+w=401wt.eu-S1763279AbXERTE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763279AbXERTE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbXERTEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:04:20 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48707 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbXERTET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:04:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, mingo@elte.hu, ak@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Zou, Nanhai" <nanhai.zou@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
Subject: Re: [patch] x86_64, irq: check remote IRR bit before migrating level triggered irq
References: <20070518010119.GB12088@linux-os.sc.intel.com>
	<m1veeqjitm.fsf@ebiederm.dsl.xmission.com>
	<20070518180749.GA26081@linux-os.sc.intel.com>
	<86802c440705181128t28652911w39d6de0c43d99a45@mail.gmail.com>
	<20070518183941.GA28957@linux-os.sc.intel.com>
Date: Fri, 18 May 2007 13:02:16 -0600
In-Reply-To: <20070518183941.GA28957@linux-os.sc.intel.com> (Suresh
	B. Siddha's message of "Fri, 18 May 2007 11:39:41 -0700")
Message-ID: <m1wsz6ymyv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Siddha, Suresh B" <suresh.b.siddha@intel.com> writes:

> On Fri, May 18, 2007 at 11:28:25AM -0700, Yinghai Lu wrote:
>> On 5/18/07, Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
>> >
>> > If the vector number stays same during irq migration and if we reset remote
>> > IRR bit using the above method(edge and then back to level) during
>> > irq migration, then we have a problem. A new interrupt arriving on a new
>> > cpu will set the remote IRR bit and now the old inflight EOI broadcast
>> > reaches IOAPIC RTE(resetting the remote IRR bit, because the vector in the
>> > broadcast msg is same), while the kernel code still assumes that the remote
>> > IRR bit is still set. This will lead to more problems and issues.
>> 
>> coud add some line __assign_irq_vector. to make sure old_vector!=vector.
>
> hmm..
> what happens when there is second(and very quick) irq migration which brings the
> irq back to old cpu(or to a third cpu) with old vector.
>
> Point is, we are not taking care of the inflight messages(which can perhaps,
> theoretically, can get delayed for long time)

I will look closer but I do believe that from the ioapic to the cpu the 2.6.21
code should be fairly robust with respect to inflight messages from the ioapic
to the local apics and the cpus.  What I failed to consider were inflight
messages in the other direction arriving out of order.

Part of the problem in the general case is the only way you can tell an inflight
message was transmitted is that a message that you can prove followed the first
message arrives somewhere.

I'm in the middle of tracking two other problems so I can't review this in
detail until later today at the earliest.
 
Eric

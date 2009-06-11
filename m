Return-Path: <linux-kernel-owner+w=401wt.eu-S1762656AbZFKKjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762656AbZFKKjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761708AbZFKKjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:39:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:37397 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759794AbZFKKjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:39:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,202,1243839600"; 
   d="scan'208";a="420808486"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Thu, 11 Jun 2009 11:39:37 +0100
Subject: RE: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
	trace support"
Thread-Topic: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
	trace support"
Thread-Index: Acnqfn5sik38jbG4TM6OZESkLKNzDgAAFGZQ
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EBBC6555D@irsmsx504.ger.corp.intel.com>
References: <tip-511b01bdf64ad8a38414096eab283c7784aebfc4@git.kernel.org>
 <928CFBE8E7CB0040959E56B4EA41A77EBBC6544B@irsmsx504.ger.corp.intel.com>
 <1244702183.6691.8.camel@laptop> <20090611102159.GA31719@elte.hu>
In-Reply-To: <20090611102159.GA31719@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Thursday, June 11, 2009 12:22 PM
>To: Peter Zijlstra
>Cc: Metzger, Markus T; linux-kernel@vger.kernel.org; mingo@redhat.com; hpa@zytor.com; oleg@redhat.com;
>tglx@linutronix.de; linux-tip-commits@vger.kernel.org
>Subject: Re: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
>
>
>* Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Thu, 2009-06-11 at 07:30 +0100, Metzger, Markus T wrote:
>> > >-----Original Message-----
>> > >From: tip-bot for Ingo Molnar [mailto:mingo@elte.hu]
>> > >Sent: Thursday, June 11, 2009 1:37 AM
>> > >To: linux-tip-commits@vger.kernel.org
>> > >Cc: hpa@zytor.com; mingo@redhat.com; peterz@infradead.org; Metzger, Markus T; oleg@redhat.com;
>> > >tglx@linutronix.de; mingo@elte.hu
>> > >Subject: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
>> > >
>> > >Commit-ID:  511b01bdf64ad8a38414096eab283c7784aebfc4
>> > >Gitweb:     http://git.kernel.org/tip/511b01bdf64ad8a38414096eab283c7784aebfc4
>> > >Author:     Ingo Molnar <mingo@elte.hu>
>> > >AuthorDate: Thu, 11 Jun 2009 00:32:00 +0200
>> > >Committer:  Ingo Molnar <mingo@elte.hu>
>> > >CommitDate: Thu, 11 Jun 2009 00:32:00 +0200
>> > >
>> > >Revert "x86, bts: reenable ptrace branch trace support"
>> > >
>> > >This reverts commit 7e0bfad24d85de7cf2202a7b0ce51de11a077b21.
>> > >
>> > >A late objection to the ABI has arrived:
>> > >
>> > >   http://lkml.org/lkml/2009/6/10/253
>> >
>> > I thought that this has been resolved. See for example http://lkml.org/lkml/2009/6/10/257.
>> >
>> > Peters concerns were that Debug Store details are exposed to user space, which is
>> > not the case. Debug Store itself is fully in-kernel and the expectation of a
>> > user-defined buffer can be implemented on top of the Debug Store changes that
>> > Peter expects are needed to support PEBS.
>> >
>> > A user-defined trace buffer size is required to support
>> > different usage models. Some users only need a small amount of
>> > trace, whereas others need a big amount. The interface will have
>> > to reflect that in some way.
>>
>> Right, your last email did explain how we could keep per task
>> in-kernel buffers and fill them from the DS and still have them of
>> user-specified size.
>>
>> That would indeed keep the proposed ABI workable, what I'm still
>> not liking is that this buffer is in-kernel, but I guess that
>> might be something for other people to have an opinion on.
>
>Hm. Wrt. the ABI, wouldnt it make more sense to expose this PMU
>feature via perfcounters: a sampling hw-branch-executions counter,
>with interval=1.
>
>That would give the exact existing semantics, plus a lot lot more.
>Markus?

What more would we get?

I take it that you don't want to implement branch tracing via PEBS,
which would be possible but rather inefficient since the BTS format
is much more compact than the PEBS format.

So we would still implement it via BTS and we would still like to present
a branch trace specific format to the user.

Are you suggesting to use a common ABI for sampling and branch tracing?

The existing ABI is tailored towards the expected users: debuggers.
I do believe that a ptrace based interface makes a lot of sense for
this debugging-related feature, since debuggers already speak ptrace.

Branch tracing and sampling are used by different classes of user-mode
applications. I don't think that a common ABI would benefit user-mode.
Since we do need different implementations in the kernel, I don't see
how a common ABI would help here, either.


I rather see this as two independent, unrelated hardware features that
happen to use the same technique to allow arbitrary-sized buffers and
that therefore share some hardware real-estate.


regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


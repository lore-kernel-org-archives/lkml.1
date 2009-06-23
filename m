Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZFWHgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZFWHgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFWHg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:36:28 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48221 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZFWHg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=hsEXybdqpt977zA2oMhE37307zumSxNXzH/tnba/D2fL6DPckHfFMido/dR2FR4yAB
         VlKVQNxjsFEQ7TIGi3De7+Wa3k1BpG/eWb8Gwm4ISCGcLdx+zOdN2qcSZOg4ERbiAE/z
         JD3PZip9jz5iCwaHQFLgimxkrPK4e4C1L87R0=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <19008.25905.550815.222975@drongo.ozlabs.ibm.com>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622115017.GC24366@elte.hu>
	 <19008.25905.550815.222975@drongo.ozlabs.ibm.com>
Date: Tue, 23 Jun 2009 09:36:28 +0200
Message-ID: <7c86c4470906230036o677e6c48j923a7431b9912372@mail.gmail.com>
Subject: Re: I.2 - Grouping
From: stephane eranian <eranian@googlemail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 7:16 AM, Paul Mackerras<paulus@samba.org> wrote:
> Ingo Molnar writes:
>
>> > 2/ Grouping
>> >
>> > By design, an event can only be part of one group at a time.
>
> To clarify this statement of Stephane's, a _counter_ can only be in
> one group.  You can have multiple counters counting the same _event_
> and those counters can (obviously) be in different groups.
>
Okay.

What happens if I do:
   fd0 = perf_counter_open(&hwc1, getpid(), -1, -1, 0);
   fd1 = perf_counter_open(&hwc2, getpid(), -1, fd0, 0);

And then:
   fd2 = perf_counter_open(&hwc2, getpid(), -1, fd1, 0);

>> > Events in a group are guaranteed to be active on the PMU at the
>> > same time. That means a group cannot have more events than there
>> > are available counters on the PMU. Tools may want to know the
>> > number of counters available in order to group their events
>> > accordingly, such that reliable ratios could be computed. It seems
>> > the only way to know this is by trial and error. This is not
>> > practical.
>>
>> Groups are there to support heavily constrained PMUs, and for them
>> this is the only way, as there is no simple linear expression for
>> how many counters one can load on the PMU.
>
> That's not the only reason for having groups, or even the main reason
> IMO.  The main reason for having groups is to provide a way to ask the
> scheduler to ensure that two or more counters are always scheduled
> together, so that you can meaningfully do arithmetic operations on the
> counter values that would be sensitive to the statistical noise
> introduced by the scheduling, such as ratios and differences.
>
> In other words, grouping is there because we don't guarantee to have
> all counters scheduled onto the PMU whenever possible.  Heavily
> constrained PMUs increase the need for scheduling, but even if
> counters are completely orthogonal there are only a fixed number of
> them so we still need to schedule counters at some point.
>
I agree completely.

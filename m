Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0BJLXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 06:23:31 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:47229 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab0BJLXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 06:23:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QqcZ0Ns+GGOy7OtXeZbMo+hwy1/HZ4UhIbkFCg2tR1I7pbGPqoKa02ocITqtK4ykLi
         xZzjzxLmkvV1GDZjK2gCrWqwf4K4cD9pZpn3K3wccI/tG35ySC656UVUHEJ5lvBOOd6H
         EXwb9AyeMpTTslzR1xsCExqvThRdI770ARM5g=
MIME-Version: 1.0
In-Reply-To: <1265799175.11509.271.camel@laptop>
References: <20100208184504.GB5130@lenovo> <20100209041739.GA11280@elte.hu>
	 <20100209223909.GE5068@lenovo> <1265796732.11509.260.camel@laptop>
	 <aa79d98a1002100238v256ca6daw5e00c8b6d8dc4bb6@mail.gmail.com>
	 <1265799175.11509.271.camel@laptop>
Date: Wed, 10 Feb 2010 14:23:27 +0300
Message-ID: <aa79d98a1002100323v3a8e8211k309b5edfc3491ecb@mail.gmail.com>
Subject: Re: [RFC perf,x86] P4 PMU early draft
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/10, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-02-10 at 13:38 +0300, Cyrill Gorcunov wrote:
>> > I'd try BUG_ON(cpu != smp_processor_id()) and scrap passing that cpu
>> > thing around.
>> >
>>
>> no, i need cpu to find out if event has migrated from other thread and
>> then i switch
>> some thread dependant flags in hw::config (ie escr and cccr), or i
>> miss something and events in one cpu just can't migrate to another
>> cpu?
>
> Well, if we validate that cpu == smp_processor_id() (looking at
> kernel/perf_event.c that does indeed seem true for
> hw_perf_group_sched_in() -- which suggests we should simply remove that
> cpu argument), and that cpu will stay constant throughout the whole
> callchain (it does, its a local variable), we can remove it and
> substitute smp_processor_id(), right?
>

yeah, seems so!

> As to migration of the event, its tied to a task, we're now installing
> the event for a task it wouldn't make sense to allow that to be
> preemptible.
>
>

ok, thanks for explanation, Peter! I'll take a closer look as only get
back from office.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZFWRvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZFWRvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZFWRvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:51:11 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:38748 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZFWRvK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:51:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=o9E7iHTcYKr7XY/Ok6qB9YQuuOpI75IWzZTHmCIhtKRWVkGnD1T6Fxge7I3xyVkrWX
         /eQWzTE+8lMHmwxns51SszGfXiR8IB2/GP+KV4aMj37/tNhx5QEC/d3g9NwLwh/xPmAK
         /EIpGJlnvTB+JACDGl5y5ChURWrStN4JSdc5E=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <4A3FFFD3.3090008@linux.vnet.ibm.com>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622115017.GC24366@elte.hu>
	 <7c86c4470906221245m6b1c2bc5nb03e4f5730db6396@mail.gmail.com>
	 <4A3FFFD3.3090008@linux.vnet.ibm.com>
Date: Tue, 23 Jun 2009 19:51:10 +0200
Message-ID: <7c86c4470906231051p102d259bu7a20b30364720d9a@mail.gmail.com>
Subject: Re: I.2 - Grouping
From: stephane eranian <eranian@googlemail.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, cel@linux.vnet.ibm.com,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey,

On Tue, Jun 23, 2009 at 12:04 AM, Corey
Ashford<cjashfor@linux.vnet.ibm.com> wrote:
> stephane eranian wrote:
>>
>> On Mon, Jun 22, 2009 at 1:50 PM, Ingo Molnar<mingo@elte.hu> wrote:
>>>>
>>>> 2/ Grouping
>>>>
>>>> By design, an event can only be part of one group at a time.
>>
>> As I read this again, another question came up. Is the statement
>> above also true for the group leader?
>>
>>
>>>> Events in a group are guaranteed to be active on the PMU at the
>>>> same time. That means a group cannot have more events than there
>>>> are available counters on the PMU. Tools may want to know the
>>>> number of counters available in order to group their events
>>>> accordingly, such that reliable ratios could be computed. It seems
>>>> the only way to know this is by trial and error. This is not
>>>> practical.
>>>
>>> Groups are there to support heavily constrained PMUs, and for them
>>> this is the only way, as there is no simple linear expression for
>>> how many counters one can load on the PMU.
>>>
>> But then, does that mean that users need to be aware of constraints
>> to form groups. Group are formed by users. I thought, the whole point
>> of the API was to hide that kind of hardware complexity.
>>
>> Groups are needed when sampling, e.g., PERF_SAMPLE_GROUP.
>> For instance, I sample the IP and the values of the other events in
>> my group.  Grouping looks like the only way to sampling on Itanium
>> branch buffers (BTB), for instance. You program an event in a generic
>> counter which counts the number of entries recorded in the buffer.
>> Thus, to sample the BTB, you sample on this event, when it overflows
>> you grab the content of the BTB. Here, the event and the BTB are tied
>> together. You cannot count the event in one group, and have the BTB
>> in another one (BTB = 1 config reg + 32 data registers + 1 position reg).
>>
>
> Stephane, if you were to just place into groups those events which must be
> correlated, and just leave all of the others not grouped, wouldn't this
> solve the problem?  The kernel would be free to schedule the other events
> how and when it can, but would guarantee that your correlated events are on
> the PMU simultaneously.
>
It would work.

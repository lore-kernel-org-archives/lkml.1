Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbZHLMW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbZHLMW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZHLMW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:22:27 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49738 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZHLMW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=q3eFGd1oLm5qyJ3el9sw2X210L2sODx1HhXx1P9AHVduoepBBAuKZGQP2xAthW5GDP
         zdCICZ9ANK7GNGr9OCQJZ6IzVdC/wD6TK7D0H9LVwRVijAIbpeViMIwcWyQlKlES/aKX
         uQNF/nf0m+7yCw7TMLEuLGk7y0cHPWL6PrO7Y=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090812090234.GB14114@elte.hu>
References: <7c86c4470908110841wca07382gf7487c0ed55909f2@mail.gmail.com>
	 <1250006744.10001.29.camel@twins>
	 <7c86c4470908111240s58385748wdb3c3e4a0d66a1ea@mail.gmail.com>
	 <1250024143.7091.7.camel@laptop>
	 <7c86c4470908111408x256e294i13ac90035fd8f5c8@mail.gmail.com>
	 <1250065963.10001.30.camel@twins> <20090812090234.GB14114@elte.hu>
Date: Wed, 12 Aug 2009 14:22:25 +0200
Message-ID: <7c86c4470908120522m1eaf891bqb394df072dddc701@mail.gmail.com>
Subject: Re: perf_counters issue with PERF_SAMPLE_GROUP
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 11:02 AM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>> On Tue, 2009-08-11 at 23:08 +0200, stephane eranian wrote:
>>
>> > But aren't you going to change the cpu, pid target stuff we
>> > discussed a couple of weeks ago anyway?
>>
>> Right, I'd like to, but Ingo doesn't. I haven't heard back from
>> Paul on this.
>
> Not sure we want to change it. Mixing PID and CPU into the same
> space disallows the simultaneous application of both. I.e. right now
> we allow 3 models:
>
>  - PID-ish
>  - CPU-ish
>  - PID and CPU [say measure CPU#2 component of an inherited workload.]
>
How useful is that last model, especially why only one CPU?

> Also, i dont really see the use-cases for new targets. (i've seen a
> few mentioned but none seemed valid) What new targets do people have
> in mind?

I seem to recall people mentioned:
   1- CPU socket, e.g., uncore PMU
   2- chipset
   3- GPU

I can see 1/ being indirectly achievable by specifying a CPU.
But the others are uncorrelated to either a CPU or thread.
I have already seen requests for accessing chipsets, and
seems GPU are around the corner now.

Why do you think those would be invalid targets given
the goal of this API?

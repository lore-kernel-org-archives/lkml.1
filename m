Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZFRV6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZFRV6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZFRV6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:58:35 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56697 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbZFRV6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:58:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=qIRN8B28kx7r2PTEiD56suAWSXEfQWUWXUO6qju+1lZlUbpvnWBtin1o8PVkaxRnVl
         MDd4iqbj+j4DZkOsyzEFplNEqYr9NpaYISelLrRzhbmRpu48x+3D8OPgkq8TT6smK4r/
         RiQ/Yu8nqYuAhrgpmnXH3srHkuViYWyjFCPsc=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090612102804.GA15914@elte.hu>
References: <20090611160329.GA3366@elte.hu>
	 <7c86c4470906120256m545363d4h85a3e84a88291ac7@mail.gmail.com>
	 <20090612102804.GA15914@elte.hu>
Date: Thu, 18 Jun 2009 23:58:35 +0200
Message-ID: <7c86c4470906181458l6985e13av6c503b34e4f3b1d3@mail.gmail.com>
Subject: Re: [GIT PULL] Performance Counters for Linux
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 12, 2009 at 12:28 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
>>
>> On Thu, Jun 11, 2009 at 6:03 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> > The counter concept got objected to in past discussions on lkml,
>> > by DaveM and by Stephane Eranian (i've Cc:-ed them) - so this
>> > code was not eligible for linux-next testing - nevertheless we
>> > gave it good testing on PowerPC and x86 and i've done a wide
>> > cross-build test as well to try to make sure it breaks no other
>> > architecture.
>>
>> I don't think you can quote me saying "I object to this code".
>> [...]
>
> I never saw you retract/change this negative opinion of yours about
> the whole separate-counters concept:
>
>  " In summary, although the idea of simplifying tools by moving the
>    complexity elsewhere is legitimate, pushing it down to the
>    kernel is the wrong approach in my opinion, perfmon has avoided
>    that as much as possible for good reasons. "
>
>    http://lkml.org/lkml/2008/12/5/359
>

I, indeed, did not retract because I still have reservations about the approach
even after 6 months of intense development.

> Do you like the concept now? That would be great news - you have a
> lot of experience with various PMU details and we could certainly
> welcome help with the perf tool and with the kernel side of
> perfcounters!
>

I still have reservations. I could be convinced, though. But for that to happen,
there are a couple of milestones that need to be reached:
        - Full Intel Nehalem support: core PMU, uncore PMU, LBR, PEBS
(incl. load latency),
          offcore_response.
        - Full Intel Itanium 2 dual-core (Montecito) support: D-EAR,
I-EAR, opcode matching, range
          restrictions, user level control

Those represent very advanced and very useful PMUs. Having implemented
user and kernel
support for both of  them, I can attest that they challenge any
interfaces. But perfmon is the proof
that those can be  exposed with their full strength thru a generic
kernel API. Therefore, I am
relatively hopeful, there should be a way to expose them through your API.

Another important consequence of your design is that the event
assignment logic is in the kernel.
As discussed early on, this can be quite complicated. Today, you only
have very partial support
for architected Intel X86 and AMD64 processors (I know about Power). I
am sure you will update
this shortly. But I think getting complete support for Intel Nehalem
and Itanium 2 in that area is
another important milestone.

Concerning help, I am sure you realize I am already helping you out by posting
detailed reviews. I have yet to see anybody else posting this kind of
information
concerning your API. I will keep posting as I find new issues. My goal is not to
torpedo this API, it's already upstream anyway, but instead I am
trying to ensure
it does what I want based on my experience developing tools, talking with PMU
architects and feedback from tool developers.

I think we could have a much more constructive working relationship if
people showed
some more respect for the work I and many others have done. Perfmon
certainly has
issues and could be implemented better. You certainly have better
skills than me in that
area. I have no problem admitting that. But I do not think perfmon
deserves the kind of
comments I have seen, repeated over and over, from you and Zijlstra
since December.
Regardless of your personal opinion, perfmon deserves some credit for
what it has offered
to many people around the world. If it had been as bad as you
described it, it could not
possibly have supported all the PMUs and their advanced features.
Nobody would have
used it. But this is not what happened.

>> [...]  I posted a detailed review of the API and implementation on
>> X86 outlining lots of issues. Some got fixed, but many others are
>> left unresolved at this point. And I will post some more shortly.
>
> Hm, Peter replied to you mail a week ago, in detail. We addressed a
> good number of issues pointed out by you, and we credited you for
> them:
>
> earth4:~/tip> git log v2.6.30..linus | grep 'Reported-by: Stephane Eranian'
>    Reported-by: Stephane Eranian <eranian@googlemail.com>
>    Reported-by: Stephane Eranian <eranian@googlemail.com>
>    Reported-by: Stephane Eranian <eranian@googlemail.com>
>    Reported-by: Stephane Eranian <eranian@googlemail.com>
>    Reported-by: Stephane Eranian <eranian@googlemail.com>
>    Reported-by: Stephane Eranian <eranian@googlemail.com>
>    Reported-by: Stephane Eranian <eranian@googlemail.com>
>
I know. I appreciate that. I wish you had also acknowledged the fact
that I suggested that you split the config field into type and config fields
in my initial posting. I had to discover this change by looking at the GIT
log.

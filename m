Return-Path: <linux-kernel-owner+w=401wt.eu-S934550AbZDCO4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550AbZDCO4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbZDCOvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:51:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:39752 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547AbZDCOvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IdMIWJKljdd/QflbKfmNa+fxMwZddOM3XjeoVYBxZli1kFqPeUkR/GqKzp0Fxly99i
         sVR6Z2WFnTsarJLgRxwGQytmjgnSkNaenXX7D+k5HpQHyJJMIOZ5biNzePS1dWzThFLv
         D1dQ+jpxr1vBdBSXdNuw/6tkERnTyRqOyX+88=
MIME-Version: 1.0
In-Reply-To: <dc864f960904020946y5fcebfdfy7679d2bd9ab3dc5e@mail.gmail.com>
References: <a6b9f31a0904010758r23767adco16ea4ee45d7e158e@mail.gmail.com>
	 <1238670826.8530.5837.camel@twins>
	 <a6b9f31a0904020453o2b3177b7p99bcf332131e2f5b@mail.gmail.com>
	 <dc864f960904020946y5fcebfdfy7679d2bd9ab3dc5e@mail.gmail.com>
Date: Fri, 3 Apr 2009 23:51:12 +0900
Message-ID: <a6b9f31a0904030751n85da75dnc3b6ad10767e7a72@mail.gmail.com>
Subject: Re: [RFC] Improving scheduler for asymmetric multi-core processor in 
	Google's summer of code
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Amithash Prasad <amithash@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 3, 2009 at 01:46, Amithash Prasad <amithash@gmail.com> wrote:
> Yes, I have something similar up going towards my master's thesis.
> But in the beginning I chose to have it as a kernel module rather than in
> the kernel, and as a direct consequence, it is a mess with kprobes
> everywhere.
> And as Peter mentioned it is very delicate. I have not even touched on all
> possible aspects and not a bit proud about my code. I will have more
> detailed performance graphs, and my defense is in 2 weeks. Once that is
> over, I will share the results with you.
> As far as I have noticed, the scheduler does have NUMA support.

It's wonderful for me. I'm looking forward to watching your result.
More power to you!

>
> On Thu, Apr 2, 2009 at 5:53 AM, Hitoshi Mitake <h.mitake@gmail.com> wrote:
>>
>> On Thu, Apr 2, 2009 at 20:13, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, 2009-04-01 at 23:58 +0900, Hitoshi Mitake wrote:
>> >> Hi,
>> >>
>> >> I found an interesting problem, scheduling on Asymmetric multi-core
>> >> processor.
>> >>
>> >> According to this paper,
>> >>
>> >>
>> >> http://portal.acm.org/citation.cfm?id=1362694&dl=GUIDE&coll=GUIDE&CFID=28487975&CFTOKEN=68150071
>> >>
>> >> taking performance asymmetry into consideration on multi-core CPUs can
>> >> improve scheduler performance.
>> >> (And I think discarding this could have bad consequences.)
>> >>
>> >> So I have a question:
>> >> Is the current scheduler of Linux aware of possible performance
>> >> asymmetry of the cores?
>> >
>> > It does not.
>> >
>> >> By performance asymmetry I mean a case where different cores run on
>> >> different frequencies.
>> >>
>> >> If something tackling this issue is not implemented yet,
>> >> I would like to work on that as a project of Google's summer of code.
>> >
>> > Have at it.
>> >
>> > Its a rather delicate business though and should also include scaling
>> > balancing decisions based on time taken by IRQs and RT tasks as well as
>> > incorporate feedback from the cpu. The latter includes things like
>> > cpufreq, but also effective work done by threads on a core.
>> >
>> > Its been on my todo list for quite a while, but haven't managed to get
>> > something robust together.
>> >
>>
>> Amithash and Peter,
>>
>> I evaluated the performance of Linux on ASMP.
>> I made web page to describe this:
>> http://www.dcl.info.waseda.ac.jp/~mitake/asmp/
>> because I want to use some pictures for easy to read.
>> (Sorry for my broken English! I'm Japanese and not good at English.)
>>
>> And it seems that there's no problem at least on my evaluation.
>> So I can't define problem clearly now. I pass this year's
>> GSoC.(Deadline is coming soon.)
>>
>> But I'll continue to research ASMP as a private project.
>> As Peter told, this is delicate business.
>> For example, this may be more difficult problem when realtime task exists.
>> (Setting frequency low may be fatal for deadline of RT tasks.)
>>
>> Thanks a lot!
>>
>> Hitoshi
>
>
>
> --
> Amithash E. Prasad
> ECE Department, CU
> http://eces.colorado.edu/~prasadae
>

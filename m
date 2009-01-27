Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZA0Mue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZA0Mue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 07:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZA0MuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 07:50:25 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:28591 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZA0MuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 07:50:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tR60urB90YWrDQWcBXRvcqWmTqY28T4DRP9aFwLZwkPbwX5cQM/6/Q0tnCn1TGbcgM
         +tPziC/0Jv6Od4Q8Pw8yCojKnb+6GgWIa4k3chiaKrz97y/W1Cj+BfxLNvrTC2YDk/2X
         8wFOK+qMbfehCDqwh9L5w5dFCqLGZFttNRPIQ=
MIME-Version: 1.0
In-Reply-To: <497EF43D.9010303@gmail.com>
References: <20090126103243.GA31307@elte.hu>
	 <1232977445-11815-1-git-send-email-brgerst@gmail.com>
	 <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org>
	 <497E8778.9060503@gmail.com>
	 <1233032609.3248.78.camel@localhost.localdomain>
	 <497E9B9D.4010102@gmail.com> <20090127113734.GA28249@elte.hu>
	 <497EF43D.9010303@gmail.com>
Date: Tue, 27 Jan 2009 07:50:23 -0500
Message-ID: <73c1f2160901270450hb27a1e8ya4ea298b2e601dc9@mail.gmail.com>
Subject: Re: [PATCH 1/2 #tj-percpu] x86: fix build breakage on voyage
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 6:47 AM, Tejun Heo <htejun@gmail.com> wrote:
> Hello, Ingo.
>
> Ingo Molnar wrote:
>>> +#ifdef CONFIG_X86_LOCAL_APIC
>>>      early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
>>>      early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
>>> +#endif
>>
>> That patch is not acceptable - it is ugly and it adds another set of
>> #ifdefs to an already complex piece of code.
>
> Well, although the patch itself does add #ifdef, if you look over the
> whole series, voyager is now a much more conforming citizen in the x86
> world.  There are several solutions to this particular one.
>
> 1. Just let apic stuff defined and not use it in voyager if the ifdef
>   is disturbing.  IIUC, apic isn't used in voyager at all, right?
>
> 2. Clean up early percpu stuff so that it each early percpu variable
>   doesn't need to be explicitly copied and cleared, which is the
>   actual problem here.
>
> 3. But, then again, the current interim and ugly way of doing it isn't
>   too bad considering the small number of early per cpu users.
>
> To me the current form doesn't look too bad but if it's too ugly,
> maybe doing #2 is not such a bad idea such that early percpu can be
> transferred to percpu in more systematic way.  It still feels a bit
> like overdoing it tho.
>
> What do you think?

I thought about ways to make the early percpu code more general, but
with only three current users, any solution seemed to be overkill.
What I can do is eliminate the pointers and use a single flag to mark
the early maps as dead.

--
Brian Gerst

Return-Path: <linux-kernel-owner+w=401wt.eu-S933620AbZJMHSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbZJMHSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbZJMHSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:18:05 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:33881 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567AbZJMHSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=b2fog4oYmxuxJUSECvfYprN9/AihIvr8bJVOdUP73l7XjMG5oQ+wIYY0Pj41wv8LFc
         UT9hRC8BTW5sBeRl5PqP/1dU8TW07M7fsEZXvdsliVQXTaR6NU2I+wp8y5ndgtoEVw2u
         kgxCqiTIvABqs2jPoLbU8w8RXjf2L5RZW7NIo=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20091012090515.GA24031@elte.hu>
References: <1254911461.26976.239.camel@twins>
	 <19148.30773.350036.411105@cargo.ozlabs.ibm.com>
	 <7c86c4470910070531s8ff0d54xb29c22dd982aa387@mail.gmail.com>
	 <20091007.134626.238756485.davem@davemloft.net>
	 <20091008200839.GA24354@elte.hu>
	 <7c86c4470910081328r24be0f63ha436b008b66077c4@mail.gmail.com>
	 <20091012090515.GA24031@elte.hu>
Date: Tue, 13 Oct 2009 09:17:25 +0200
Message-ID: <7c86c4470910130017s72e0b936u3eee0caba00acd22@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for Intel 
	processors
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, paulus@samba.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 11:05 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> The event constraints we are interested in come from the physics of
> CPUs, not from inherent properties of particular architectures.
>
I don't understand this statement.

> If you check the various constraints you'll see there's many repeating
> patterns and many of those will repeat between architectures.
>
Some are similar and I have mentioned them but also many are specific.

> Arbitrary, random constraints (that stem from design stupidity/laziness)
> can be kept at arch level, as a quirk in essence.
>
We have had a discussion about event constraints early on. I think you and
I have a different appreciation on why they exist. I don't think it would be
fruitful to restart this. Constraints exist, they will most likely
always be there.
You can choose to ignore them, drop the constrained features, or add the
code to deal with them when the feature is worth it.

> Spreading them all out into architecture code is the far worse solution,
> it creates a fragile distributed monster with repeating patterns -
> instead we want a manageable central monster ;-) [We are also quite good
> at controlling and shrinking monsters in the core kernel.]
>
I don't understand this either.
Why would architecture specific code be more fragile ?

> So we could start all this by factoring out the sane looking bits of
> PowerPC and x86 constraints into generic helpers, and go step by step
> starting from that point.
>
> Would you be interested in trying that, to finish what you started with
> 'struct event_constraint' in arch/x86/kernel/cpu/perf_event.c?

I have already started this effort because what is there now, though correct,
is still not satisfactory. But I have decided to first try to
implement it in the
X86 specific code to gauge what is actually needed. Then, we may be able
to promote some code to the generic layer.

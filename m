Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbZFLPRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbZFLPRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZFLPRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:17:11 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:55136 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZFLPRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=L7mb9xmSeE/ASCfooKTzR/01UPTMDG/q5ISqL3aeUs9UH1ayapdiqZi7e0p47b27ag
         JKUQcDZwlzIVLRe148cjyS2vgGNYisE6qp6+LAulPj4p5agv9twnSdYj9nqjlvcnbARE
         JL3k108VZzP/wz1a0qwTaADtLk09s/PeS5TVI=
MIME-Version: 1.0
In-Reply-To: <20090612120507.GH16044@elte.hu>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> 
	<20090612120507.GH16044@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 11:16:52 -0400
Message-ID: <8bd0f97a0906120816w26d91530nf1e1967470beb99c@mail.gmail.com>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open 
	when supported
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 08:05, Ingo Molnar wrote:
> * Mike Frysinger <vapier@gentoo.org> wrote:
>> If the port does not support HAVE_PERF_COUNTERS, then they can't
>> support the perf_counter_open syscall either.  Rather than forcing
>> everyone to add an ignore (or suffer the warning until they get
>> around to implementing support), only whine about the syscall when
>> applicable.
>
> No, this patch is wrong - it's really easy to add support: just hook
> up the syscall. This should happen for every architecture really, so
> the warning is correct and it should not be patched out.
>
> PMU support is not required to get perfcounters support: if an
> architecture hooks up the syscall it will get generic software
> counters and the tools will work as well.
>
> Profiling falls back to a hrtimer-based sampling method - this is a
> much better fallback than oprofile's fall-back to the timer tick.
> This hrtimer based sampling is dynticks/nohz-correct and can go
> beyond HZ if the architecture supports hrtimers.

these statements are actually incorrect.  the perf counter code
explicitly requires:
 - asm/perf_counter.h
 - support for atomic64 types (unless i missed something, x86 is the
only 32bit system that supports these)
 - some perf stubs (like set_perf_counter_pending() -- prototype
really should be in common perf_counters headers rather than forcing
the arch to copy & paste the exact same line)

not that any of this is documented ...
-mike

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZFLMW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZFLMW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZFLMWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:22:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:23907 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZFLMWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PNSdmQwBw6WNZkKtATz9ZcqH5FhaLEeAHhlyYcUbsI8y2fe/BCd+kcJI+UNQWhD1xn
         VVzqwdai71ILiP8ZpSs3byaGsxwWNB0ecDUjFFbgKn0kBDKzjL+RRYNyc860eZzpTYLj
         WD6WMAwMTXscT3NfROltycoTJgWpKw3s/I0hQ=
MIME-Version: 1.0
In-Reply-To: <20090612121757.GD31845@elte.hu>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> 
	<20090612120507.GH16044@elte.hu> <8bd0f97a0906120513u4e823460t8192f00fd0460ab@mail.gmail.com> 
	<20090612121757.GD31845@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 08:22:30 -0400
Message-ID: <8bd0f97a0906120522v51ae0151i48d5f6846ddcff10@mail.gmail.com>
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

On Fri, Jun 12, 2009 at 08:17, Ingo Molnar wrote:
> * Mike Frysinger <vapier.adi@gmail.com> wrote:
>> On Fri, Jun 12, 2009 at 08:05, Ingo Molnar wrote:
>> > * Mike Frysinger <vapier@gentoo.org> wrote:
>> >> If the port does not support HAVE_PERF_COUNTERS, then they can't
>> >> support the perf_counter_open syscall either.  Rather than forcing
>> >> everyone to add an ignore (or suffer the warning until they get
>> >> around to implementing support), only whine about the syscall when
>> >> applicable.
>> >
>> > No, this patch is wrong - it's really easy to add support: just hook
>> > up the syscall. This should happen for every architecture really, so
>> > the warning is correct and it should not be patched out.
>> >
>> > PMU support is not required to get perfcounters support: if an
>> > architecture hooks up the syscall it will get generic software
>> > counters and the tools will work as well.
>> >
>> > Profiling falls back to a hrtimer-based sampling method - this is a
>> > much better fallback than oprofile's fall-back to the timer tick.
>> > This hrtimer based sampling is dynticks/nohz-correct and can go
>> > beyond HZ if the architecture supports hrtimers.
>>
>> if there is generic support available, why must every arch select
>> HAVE_PERF_COUNTERS in their Kconfig ?
>
> Because we only want to enable it on architectures that have tested
> it. It should only need a syscall addition, but nothing beats having
> tested things, hence we have that additional Kconfig symbol.

that is a pretty weak reason.  nothing changes by default -- people
still have to go in and enable it.  arch people have to jump through
hoops for absolutely no reason.  if it were enabled by default, arches
could simply hook up the syscall and then random people could test it
regardless of the arch people noticing.  if anything, the arch syscall
hookup could be done by someone related to the prof code who really
wanted to see wider arch testing.
-mike

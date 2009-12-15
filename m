Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbZLOET1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbZLOET1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbZLOET0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:19:26 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:36189 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZLOETY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:19:24 -0500
MIME-Version: 1.0
In-Reply-To: <20091212061613.GA2822@elte.hu>
References: <f8f46736fd4e7f090ac0.1253774830@mudlark.pw.nest>
	 <tip-f83f9ac2632732bd1678150b5a03d152f912fe72@git.kernel.org>
	 <d6200be20912112155w6eca7452x550bc77330f236b0@mail.gmail.com>
	 <1260598055.6306.1.camel@marge.simson.net>
	 <20091212061613.GA2822@elte.hu>
Date: Mon, 14 Dec 2009 20:19:23 -0800
Message-ID: <d6200be20912142019t1ccdc019oe6fb7004eb65c2a3@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Set correct normal_prio and prio values 
	in sched_fork()
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, pwil3058@bigpond.net.au,
       linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Mike Galbraith <efault@gmx.de> wrote:
>
>> On Fri, 2009-12-11 at 21:55 -0800, Arve Hj??nnev??g wrote:
>> > On Mon, Oct 5, 2009 at 3:47 AM, tip-bot for Peter Williams
>> > <pwil3058@bigpond.net.au> wrote:
>> > > Commit-ID:  f83f9ac2632732bd1678150b5a03d152f912fe72
>> > > Gitweb:     http://git.kernel.org/tip/f83f9ac2632732bd1678150b5a03d152f912fe72
>> > > Author:     Peter Williams <pwil3058@bigpond.net.au>
>> > > AuthorDate: Thu, 24 Sep 2009 06:47:10 +0000
>> > > Committer:  Ingo Molnar <mingo@elte.hu>
>> > > CommitDate: Mon, 5 Oct 2009 13:42:20 +0200
>> > >
>> > > sched: Set correct normal_prio and prio values in sched_fork()
>> > >
>> > > normal_prio should be updated if policy changes from RT to
>> > > SCHED_MORMAL or if static_prio/nice is changed.
>> > >
>> > > Some paths through sched_fork() ignore this requirement and may
>> > > result in normal_prio having an invalid value.
>> > >
>> > > Fixing this issue allows the call to effective_prio() in
>> > > wake_up_new_task() to be removed.
>> > >
>> >
>> > This change causes a lot of threads with a 0 nice value to get a prio
>> > value of 140 instead of 120 (at least on my android arm msm build). I
>> > don't know if this has any impact on how they are scheduled since the
>> > load weight is unaffected, but it at least makes the output of ps more
>> > confusing.
>>
>> There's a patch in tip to correct this, hasn't swam upstream yet.
>
> just sent the pull request to Linus for the latest scheduler fixes.
> Meanwhile you can try latest -tip with the fix:
>
>  http://people.redhat.com/mingo/tip.git/README
>
>        Ingo
>

Thanks. The fix is upstream now though, so I just cherry-picked it from there.

-- 
Arve Hjønnevåg

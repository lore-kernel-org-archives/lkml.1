Return-Path: <linux-kernel-owner+w=401wt.eu-S1761926AbZLLFze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761926AbZLLFze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 00:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761862AbZLLFzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 00:55:32 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56025 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761851AbZLLFzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 00:55:22 -0500
MIME-Version: 1.0
In-Reply-To: <tip-f83f9ac2632732bd1678150b5a03d152f912fe72@git.kernel.org>
References: <f8f46736fd4e7f090ac0.1253774830@mudlark.pw.nest>
	 <tip-f83f9ac2632732bd1678150b5a03d152f912fe72@git.kernel.org>
Date: Fri, 11 Dec 2009 21:55:28 -0800
Message-ID: <d6200be20912112155w6eca7452x550bc77330f236b0@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Set correct normal_prio and prio values 
	in sched_fork()
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       pwil3058@bigpond.net.au, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 3:47 AM, tip-bot for Peter Williams
<pwil3058@bigpond.net.au> wrote:
> Commit-ID:  f83f9ac2632732bd1678150b5a03d152f912fe72
> Gitweb:     http://git.kernel.org/tip/f83f9ac2632732bd1678150b5a03d152f912fe72
> Author:     Peter Williams <pwil3058@bigpond.net.au>
> AuthorDate: Thu, 24 Sep 2009 06:47:10 +0000
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 5 Oct 2009 13:42:20 +0200
>
> sched: Set correct normal_prio and prio values in sched_fork()
>
> normal_prio should be updated if policy changes from RT to
> SCHED_MORMAL or if static_prio/nice is changed.
>
> Some paths through sched_fork() ignore this requirement and may
> result in normal_prio having an invalid value.
>
> Fixing this issue allows the call to effective_prio() in
> wake_up_new_task() to be removed.
>

This change causes a lot of threads with a 0 nice value to get a prio
value of 140 instead of 120 (at least on my android arm msm build). I
don't know if this has any impact on how they are scheduled since the
load weight is unaffected, but it at least makes the output of ps more
confusing.

-- 
Arve Hjønnevåg

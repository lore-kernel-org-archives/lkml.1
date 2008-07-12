Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYGLPsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYGLPsx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 11:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbYGLPsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 11:48:46 -0400
Received: from bruhost-2.ispvds.com ([82.146.33.243]:49760 "EHLO
	bruhost-2.ispvds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbYGLPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 11:48:45 -0400
Message-ID: <4878D259.7050403@r000n.net>
Date: Sat, 12 Jul 2008 19:48:41 +0400
From: Roman Mindalev <lists@r000n.net>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11035] System hangs on 2.6.26-rc8
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.xt.SzLcIB@albercik>
In-Reply-To: <uBi7uNfg81L.A.xt.SzLcIB@albercik>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (bruhost-2.ispvds.com [82.146.33.243]); Sat, 12 Jul 2008 17:48:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11035
> Subject		: System hangs on 2.6.26-rc8
> Submitter	: Roman Mindalev <lists@r000n.net>
> Date		: 2008-07-02 14:25 (5 days old)
> References	: http://marc.info/?l=linux-kernel&m=121500871414995&w=4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Announce: It is long history, if you don't want to read it, go directly
to assumption ;)

Short description of problem: SIGSEGV on high I/O load (reading packages
database, kernel untaring) without any records in logs

Prehistory: 2.6.26-rc7 works, 2.6.26-rc8 buggy, configs very simular.

History: In last days I compiled some 2.6.25 kernels (took it, because
it is stable) with different configs (step-by-step disabling options,
not equals in -rc7 and -rc8) and got next results:

2.6.25 (preemtible, preempt rcu, 300 Hz, snd_sequencer, snd_seq_dummy,
snd_rtctimer, snd_seq_rtctimer_default, debug_preempt, rcu_tortune_test)
- bug
2.6.25 (preemtible, preempt rcu, 300 Hz, snd_sequencer, snd_seq_dummy,
debug_preempt, rcu_tortune_test) - bug
2.6.25 (preemtible, preempt rcu, 300 Hz, snd_sequencer, debug_preempt,
rcu_tortune_test) - bug
2.6.25 (preemtible, preempt rcu, 300 Hz, debug_preempt,
rcu_tortune_test) - bug
2.6.25 (preemtible, preempt rcu, 250 Hz, debug_preempt,
rcu_tortune_test) - bug
2.6.25 (preemtible, preempt rcu, 250 Hz, snd_rtctimer, debug_preempt,
rcu_tortune_test) - bug
2.6.25 (preemtible, preempt rcu, 100 Hz, debug_preempt,
rcu_tortune_test) - bug
2.6.25 (preemtible, 250 Hz, debug_preempt, rcu_tortune_test) - bug
2.6.25 (250 Hz, rcu_tortune_test) - bug
2.6.25 (250 Hz) - bug

And I understand - problem not (only?) in kernel, problem in GCC too (I
updated whole system in June).

2.6.24 - one kernel (I'm tested from it to latest rc), which (with
time.patch) works with GCC 4.3.1
2.6.25 and above (tested with 2.6.26-rc7, 2.6.26-rc8, 2.6.26-rc9) don't
works, if compiled with this compiler version.

Then I look on my (working) kernels - 2.6.26-rc6 was compiled with GCC
4.2.4, and 2.6.26-rc7 too...

In testing purposes I took some listed kernels and recompiled them with
other GCC version.

Common results in table:
GCC 4.3.1, kernel 2.6.24 - works
GCC 4.2.4, kernel 2.6.25 - works
GCC 4.3.1, kernel 2.6.25 - bug
GCC 4.2.4, kernel 2.6.26-rc7 - works
GCC 4.3.1, kernel 2.6.26-rc7 - bug
GCC 4.2.4, kernel 2.6.26-rc8 - works
GCC 4.3.1, kernel 2.6.26-rc8 - bug

Assumption: new features (or new bugs:)) in GCC 4.3 conflicts with some
commit(s), included in kernel between 2.6.24 and 2.6.25

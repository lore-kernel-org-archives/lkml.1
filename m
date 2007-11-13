Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbXKMHAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbXKMHAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbXKMHAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:00:32 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47069 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbXKMHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:00:32 -0500
Message-ID: <47394B84.8030008@linux.vnet.ibm.com>
Date: Tue, 13 Nov 2007 12:30:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: vatsa@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Revert for cgroups CPU accounting subsystem patch
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com> <20071113060038.GC3359@linux.vnet.ibm.com> <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com>
In-Reply-To: <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Nov 12, 2007 10:00 PM, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
>>         On second thoughts, this may be a usefull controller of its own.
>> Say I just want to "monitor" usage (for accounting purpose) of a group of
>> tasks, but don't want to control their cpu consumption, then cpuacct
>> controller would come in handy.
>>
> 
> That's plausible, but having two separate ways of tracking and
> reporting the CPU usage of a cgroup seems wrong.
> 
> How bad would it be in your suggested case if you just give each
> cgroup the same weight? So there would be fair scheduling between
> cgroups, which seems as reasonable as any other choice in the event
> that the CPU is contended.
> 

Right now, one of the limitations of the CPU controller is that
the moment you create another control group, the bandwidth gets
divided by the default number of shares. We can't create groups
just for monitoring. cpu_acct fills this gap. I think in the
long run, we should move the helper functions into cpu_acct.c
and the interface logic into kernel/sched.c (cpu controller).

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

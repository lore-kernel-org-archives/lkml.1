Return-Path: <linux-kernel-owner+w=401wt.eu-S934229AbZHEMfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229AbZHEMfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934227AbZHEMfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:35:22 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:23647 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934230AbZHEMfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:35:18 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz62a3L1432R98dN936eMzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNWLMD-04-WI1-01
Date: Wed, 5 Aug 2009 14:35:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
Message-ID: <20090805123501.GF14610@erda.amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com> <20090803112220.GA22936@elte.hu> <20090803072522.1d90f15c@infradead.org> <20090804201109.GA21386@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090804201109.GA21386@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Aug 2009 12:35:02.0685 (UTC) FILETIME=[276264D0:01CA15C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.08.09 22:11:09, Ingo Molnar wrote:
> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Mon, 3 Aug 2009 13:22:20 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > This new oprofile multiplexing mechanism really overlaps the PMU 
> > > abstractions that perfcounters already provide, and i disagree 
> > > with this general direction. The code you wrote is clean though 
> > > so i've
> > 
> > is there any way that the oprofile interfaces can be written on 
> > top of the low level perf infrastructure?
> 
> Everything 'can' be done - the question is, is that the best 
> approach? The technically best interface to utilize perfcounters is 
> not to whack it into the oprofile kernel code, but to minimally 
> update the oprofile user-space code (the sample collection daemon) 
> to use the sys_perf_counter_open() system call.
> 
> It is by far the most elegant solution and needs no kernel changes 
> at all:
> 
> The oprofile daemon should open percpu sampling counters and create 
> oprofile-compatible sample files. That way the rest of the oprofile 
> user-space does not have to be touched at all. The raw event ids 
> that oprofile knows about can be used in perfcounter parameters 
> directly.
> 
> In such a mode of operation both oprofilefs and the dcookies syscall 
> can be omitted completely - all of the kernel side oprofile code 
> becomes mooted and pushed into legacy mode.
> 
> Is there any reason or oprofile property that makes this impossible 
> or undesirable to do?

The question is more if it makes sense. It's new to me dropping
user/kernel interfaces that are in use and forcing its developers to
rewrite their code. Oprofile is actively developed and in many
distros. It supports architectures perfcounters doesn't. So, what do
you want?

And why not having more than one profiling subsystem in the kernel? I
see also more than one type of car on the street though all of them
have 4 wheels.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


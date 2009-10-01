Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbZJAHqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbZJAHqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755733AbZJAHqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:46:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50287 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbZJAHqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:46:38 -0400
Date: Thu, 1 Oct 2009 09:46:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, Cliff Wickman <cpw@sgi.com>
Subject: Re: [PATCH 2/2] x86: UV hardware performance counter and topology
	access
Message-ID: <20091001074630.GA6738@elte.hu>
References: <20090930210531.GC12090@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930210531.GC12090@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2334]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russ Anderson <rja@sgi.com> wrote:

> Adds device named "/dev/uv_hwperf" that supports an ioctl interface
> to call down into BIOS to read/write memory mapped performance
> monitoring registers.

That's not acceptable - please integrate this with perf events properly. 
See arch/x86/kernel/cpu/perf_event.c for details.

Precisely what kinds of events are being exposed by the UV BIOS 
interface? Also, how does the BIOS get them? The BIOS should be left out 
of that - the PMU driver should know about and access hardware registers 
directly.

If any of this needs enhancements in kernel/perf_event.c we'll be glad 
to help out.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYAPR6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYAPR6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYAPR6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:58:41 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:22403 "EHLO
	outbound9-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418AbYAPR6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:58:40 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <478E467E.6030409@am.sony.com>
Date: Wed, 16 Jan 2008 10:01:34 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
References: <20080109232914.676624725@goodmis.org> <20080109233044.777564395@goodmis.org> <20080115214636.GD17439@Krystal> <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com> <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com> <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2008 17:56:29.0491 (UTC) FILETIME=[1EFF3030:01C85869]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> grmble. Then how do you trace preempt_disable?  As my tracer does that
> (see the last patch in the series).

One way is to make a tracer_preempt_disable() and tracer_preempt_enable(),
both of which would be 'notrace'. You could probably optimize them
as well.  The standard preempt_disable and preempt_enable don't look
very efficient (e.g. what's up with converting an increment operation into
an addition? - gak!)

Any lock you do is going to have a pretty bad effect.

In order to be able to trace as much as possible, for KFT, I implemented
my own synchronization mechanism using cmpxchg, to avoid using any of the
existing kernel locks (which change more often than you'd think, and have
weird side effects).

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================


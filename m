Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbYFBQmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbYFBQmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYFBQmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:42:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43693 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752861AbYFBQmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:42:06 -0400
Date: Mon, 2 Jun 2008 11:42:03 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Randy.Dunlap" <rddunlap@osdl.org>, suresh.b.siddha@intel.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
Message-ID: <20080602164203.GA2477@sgi.com>
References: <20080601213019.14ea8ef8.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080601213019.14ea8ef8.pj@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Sun, Jun 01, 2008 at 09:30:19PM -0500, Paul Jackson wrote:
> 
>     Do you, or someone you know, use "isolcpus="?

We use it.

>     Can we remove it?

We use isolcpus to ensure that boot-time intialization, specifically timer initialization, happens on a specific set of cpus that we won't be using for lower latency purposes.  Some of these timers will repeatedly restart themselves on the same cpu and a few do add latency (although admittedly I haven't checked timer latency recently).

Looking at tracebacks in 2.6.26-rc3 from hrtimer_init() and internal_add_timer() things still appear to be working this way, with the timer starting on the originating cpu.  If I isolate all but, say one, cpu, timers all seem to start on the unisolated cpu.

Attempts have been made to add an interface to ward timers off of specific cpus, but these have always been rejected.

> 
>     Should we remove it?

Why?
 
>     Should we first deprecate it somehow, for a while, before
>     removing it?

A better idea than just removing it.

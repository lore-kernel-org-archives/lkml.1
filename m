Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbXDRTsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbXDRTsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbXDRTsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:48:10 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1069 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXDRTsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:48:09 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 18 Apr 2007 12:48:07 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070418130813.GA31925@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704181243530.25880@alien.or.mcafeemobile.com>
References: <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com>
 <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com>
 <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org>
 <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org>
 <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org>
 <20070418130813.GA31925@holomorphy.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, William Lee Irwin III wrote:

> Thinking of the scheduler as a CPU bandwidth allocator, this means
> handing out shares of CPU bandwidth to all users on the system, which
> in turn hand out shares of bandwidth to all sessions, which in turn
> hand out shares of bandwidth to all process groups, which in turn hand
> out shares of bandwidth to all thread groups, which in turn hand out
> shares of bandwidth to threads. The event handlers for the scheduler
> need not deal with this apart from task creation and exit and various
> sorts of process ID changes (e.g. setsid(), setpgrp(), setuid(), etc.).

Yes, it really becomes a hierarchical problem once you consider user and 
processes. Top level sees a "user" can be scheduled (put itself on the 
virtual run queue), and passes the ball to the "process" scheduler inside 
the "user" container, down to maybe "threads". With all the "key" 
calculation parameters kept at each level (with up-propagation).



- Davide



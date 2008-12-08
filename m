Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYLHQNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYLHQNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYLHQM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:12:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbYLHQM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:12:57 -0500
Date: Mon, 8 Dec 2008 17:12:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] RT scheduler updates for tip
Message-ID: <20081208161246.GB4570@elte.hu>
References: <493939B1.40506@novell.com> <20081208143228.GF14856@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081208143228.GF14856@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


okay, this series is quite bad so i'm disabling it for now. I sent a 
build fix earlier today, then i triggered this build failure:

kernel/built-in.o: In function `dequeue_pushable_task':
sched.c:(.text+0x4a9f): undefined reference to `plist_del'
kernel/built-in.o: In function `enqueue_pushable_task':
sched.c:(.text+0x5734): undefined reference to `plist_del'
sched.c:(.text+0x5747): undefined reference to `plist_add'

and then this:

kernel/sched_rt.c: In function ‘next_prio’:
kernel/sched_rt.c:574: error: ‘struct rq’ has no member named ‘cpu’
kernel/sched_rt.c: In function ‘inc_rt_tasks’:
kernel/sched_rt.c:619: error: ‘rq’ undeclared (first use in this function)
kernel/sched_rt.c:619: error: (Each undeclared identifier is reported only once
kernel/sched_rt.c:619: error: for each function it appears in.)
kernel/sched_rt.c: In function ‘dec_rt_tasks’:
kernel/sched_rt.c:667: error: ‘rq’ undeclared (first use in this function)


	Ingo

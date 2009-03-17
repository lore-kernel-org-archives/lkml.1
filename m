Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZCQP2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZCQP2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZCQP2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:28:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50907 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZCQP2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:28:02 -0400
Date: Tue, 17 Mar 2009 16:27:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: wrong timestamps in ftrace?
Message-ID: <20090317152753.GD13895@elte.hu>
References: <E1Ljb4V-0005Tz-44@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ljb4V-0005Tz-44@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> I've started playing with ftrace and timestamps seem to be
> misbehaving.
> 
> # echo 0 > /sys/kernel/debug/tracing/tracing_enabled
> # echo nop > /sys/kernel/debug/tracing/current_tracer
> # echo 131072 > /sys/kernel/debug/tracing/buffer_size_kb
> # echo sched_switch > /sys/kernel/debug/tracing/current_tracer
> # echo 1 > /sys/kernel/debug/tracing/tracing_enabled
> # sleep 10
> # echo 0 > /sys/kernel/debug/tracing/tracing_enabled
> # cat /sys/kernel/debug/tracing/trace > /tmp/trace.txt
> # ls -lh /tmp/trace.txt
> -rw-r--r-- 1 root root 96K Mar 17 16:11 /tmp/trace.txt
> # head -5 /tmp/trace.txt | tail -1
>             bash-4908  [001]   212.139730:   4908:120:S   + [001]  4845:120:S
> # tail -1 /tmp/trace.txt
>      kondemand/1-1020  [001]   212.261054:   1020:115:S ==> [001]     0:140:R
> 
> So according to the timestamps the time difference between the first
> and last event was just 0.12s, which is rubbish.
> 
> This is latest git on a CoreDuo T60 notebook.  Attaching .config and
> dmesg.

There's been changes to timestamping in the tracing tree. Could you 
check whether latest -tip:

   http://people.redhat.com/mingo/tip.git/README

works better for you?

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765123AbYBMFtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765123AbYBMFtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYBMFt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:49:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:34628 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751807AbYBMFt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:49:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18nNYF9E40nVc3nQn4kHRLEgLVmByDEVi5yvhgcC6
	QWCMcw7yEmRFpX
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
From: Mike Galbraith <efault@gmx.de>
To: Olof Johansson <olof@lixom.net>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1202808206.7829.36.camel@homer.simson.net>
References: <1202554705.10287.12.camel@homer.simson.net>
	 <20080209114009.GP8953@1wt.eu> <1202564259.4035.18.camel@homer.simson.net>
	 <20080209161957.GA3364@1wt.eu> <20080210052941.GA4731@lixom.net>
	 <20080210061558.GC22137@1wt.eu> <20080210070056.GA6401@lixom.net>
	 <1202717755.21339.65.camel@homer.simson.net>
	 <20080211172648.GA7962@lixom.net>
	 <1202759926.4165.31.camel@homer.simson.net>
	 <20080211203159.GA11161@lixom.net>
	 <1202808206.7829.36.camel@homer.simson.net>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 06:49:22 +0100
Message-Id: <1202881762.27877.5.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 10:23 +0100, Mike Galbraith wrote:

> If you plunk a usleep(1) in prior to calling thread_func() does your
> testcase performance change radically?  If so, I wonder if the real
> application has the same kind of dependency.

The answer is yes for 2.6.22, and no for 2.6.24, which surprised me.

2.6.22.17-smp
homer:..local/tmp # ./threadtest2
10000000 loops time 16215 ms
10000000 loops time 16268 ms
10000000 loops time 16246 ms

homer:..local/tmp # ./threadtest3 (with usleep(1))
10000000 loops time 13938 ms
10000000 loops time 13921 ms
10000000 loops time 13898 ms

2.6.24.1-smp
homer:..local/tmp # ./threadtest2
10000000 loops time 14663 ms
10000000 loops time 14523 ms
10000000 loops time 14466 ms

homer:..local/tmp # ./threadtest3
10000000 loops time 14513 ms
10000000 loops time 14500 ms
10000000 loops time 14464 ms

echo 0 >  /proc/sys/kernel/sched_child_runs_first

homer:..local/tmp # ./threadtest2
10000000 loops time 14157 ms
10000000 loops time 14097 ms
10000000 loops time 14153 ms

homer:..local/tmp # ./threadtest3
10000000 loops time 14065 ms
10000000 loops time 14075 ms
10000000 loops time 14018 ms




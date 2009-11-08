Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbZKHJsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbZKHJsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZKHJs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:48:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36428 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZKHJs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:48:27 -0500
Date: Sun, 8 Nov 2009 10:48:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: J K Rai <jk.anurag@yahoo.com>, Mike Galbraith <efault@gmx.de>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Instantaneous snapshot of CPU schedule
Message-ID: <20091108094827.GB2845@elte.hu>
References: <256042.70547.qm@web94710.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <256042.70547.qm@web94710.mail.in2.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* J K Rai <jk.anurag@yahoo.com> wrote:

> Hello
> 
> Is there any utility using which we can take current (instantaneous) 
> snapshot of process schedule on the linux based system from user land. 
> Like use a system call or command to know what is running on each of 
> the cpus 0..n-1 (assuming n cpus in the system). Output could be like 
> tuple (pid, cpu_no).
> 
> If such utility does not exist then kindly throw some light / ideas so 
> that it could be implemented.

We have a tool that can record scheduling events and analyze/display 
them, see:

  perf sched record

  perf sched latency
  perf sched map
  perf sched trace
  perf sched replay

the latest version is in:

  http://people.redhat.com/mingo/tip.git/README

do 'cd tools/perf; make -j install' to get the 'perf' command.

Now, your specific question was 'instantaneous'. I wouldnt mind such an 
extension to 'perf sched record':

  perf sched record --snapshot

or so. Then 'perf sched map' would show which task is running on which 
CPU. Other output modes would be possible too.

Would you be interested in extending 'perf sched' in such a fashion?

	Ingo

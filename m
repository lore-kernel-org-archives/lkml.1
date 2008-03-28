Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYC1J3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYC1J3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYC1J3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:29:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47436 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbYC1J3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:29:10 -0400
Date: Fri, 28 Mar 2008 10:28:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Sanders, Rob M." <sanders-rob@zai.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       bart.vanassche@gmail.com
Subject: Re: Performance changes between 2.6.13 and 2.6.23
Message-ID: <20080328092856.GC30863@elte.hu>
References: <D108F32273D3044F8C7B24328CB7713701A4D1@york.rivers.zai.com> <2c0942db0803250941j65be093et718bb838a2779e9c@mail.gmail.com> <D108F32273D3044F8C7B24328CB7713701A4E1@york.rivers.zai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D108F32273D3044F8C7B24328CB7713701A4E1@york.rivers.zai.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sanders, Rob M. <sanders-rob@zai.com> wrote:

> Sorry to disappear for a few days, I just hadn't had time to do 
> anything at home.  Finally had some time to run some test, and at this 
> point I'm thinking that the problem is not with the kernel.  Not quite 
> sure where to look next, but I've done the following tests:
> 
> YDL4.0.91 with 2.6.13 kernel - normal speed
> YDL6.0    with 2.6.23 kenrel - 4-5x slowdown
> YDL4.1    with 2.6.15 kernel - 4-5x slowdown
> YDL4.0.91 with 2.6.15 kernel - *normal speed* - kernel config pulled from YDL4.1 install
> YDL4.0.91 with 2.6.23 kernel - failed boot

if you suspect the scheduler then please try the following suggestions i 
made in another thread:

---------->
could you run this script while such a slowdown is really prominent:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

and send me the output it generates? The output is the most useful if
you do this on a kernel that has CONFIG_SCHED_DEBUG=y and
CONFIG_SCHEDSTATS=y enabled.

on the off chance that this issue has been fixed in the soon-to-be
2.6.25 kernel, you might also want to try x86.git/latest, which is based
on the latest Linus tree and has all relevant x86 fixes and improvements
added as well:
  http://people.redhat.com/mingo/x86.git/README

several of the changes can affect performance.

a third (and most comprehensive) way to debug this would be to send me a
scheduler trace of such a slowdown, you can generate a scheduler trace
the following way:

  http://people.redhat.com/mingo/sched-devel.git/readme-tracer.txt

but we can probably give a first estimation based on the cfs-debug-info
output already. Btw., you can combine the scheduler and the x86 git tree
into a temporary unified tree by doing these two commands:

  git-checkout -b tmp x86/latest
  git-merge sched-devel/latest

(run "make oldconfig" to pick up the new config options.)

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbYC0JRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbYC0JRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbYC0JRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:17:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33921 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYC0JRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:17:30 -0400
Date: Thu, 27 Mar 2008 10:17:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kai <epimetreus@fastmail.fm>
Cc: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Serious performance regression in Wine applications and Linux
	2.6.24.*
Message-ID: <20080327091711.GD30918@elte.hu>
References: <1206310206.17373.1243881033@webmail.messagingengine.com> <2c0942db0803231522w7c66f168xf7fea72d135ba395@mail.gmail.com> <1206341873.32060.1243929851@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206341873.32060.1243929851@webmail.messagingengine.com>
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


* Kai <epimetreus@fastmail.fm> wrote:

> The issue only shows with Age of Wonders II and AoW Shadow Magic.
> 
> Every version of wine from 0.9.55 to 0.9.58, including several 
> intermediate git builds.
> 
> Xorg version 1.4.0.90, and a couple other versions (the problems has 
> persisted across a couple updates of Xorg)
> 
> Hardware rendering; using the prop. nV driver; updating that also 
> doesn't affect the issue, nor does retaining the same version.

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

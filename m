Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZGMKOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZGMKOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 06:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZGMKOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 06:14:47 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:57113 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbZGMKOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 06:14:47 -0400
X-SourceIP: 213.93.53.227
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Raistlin <raistlin@linux.it>
Cc: Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>
In-Reply-To: <1247478955.8107.24.camel@Palantir>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <1247478955.8107.24.camel@Palantir>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 12:14:40 +0200
Message-Id: <1247480080.7529.66.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 11:55 +0200, Raistlin wrote:
> > Thing is, both BWI and PEP seems to work brilliantly on Uni-Processor
> > but SMP leaves things to be desired. Dhaval is currently working on a
> > PEP implementation that will migrate all the blocked tasks to the
> > owner's cpu, basically reducing it to the UP problem.
> > 
> Nice... Only one question, doesn't this impact with task affinity
> related issues?

No :-), well maybe.

Since the task is blocked and will this not actually run, we can place
it on any CPU, only once it becomes runnable again should we take care
to place it on a CPU that's part of its affinity mask.

Of course, underlying this is the question of what to do for
'partitioned' tasks sharing a resource. I think we've talked about this
a few times.

Since these 'partitioned' tasks do share a resource, they're not really
all that partitioned, and I think the best way to keep the system going
is to simply Inherit/Donate/Proxy right through the partition.

~ Peter


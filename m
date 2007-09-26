Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbXIZJf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbXIZJf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbXIZJfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:35:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbXIZJfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:35:16 -0400
Date: Wed, 26 Sep 2007 11:34:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20070926093445.GA24768@elte.hu>
References: <20070926085202.GE3337@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926085202.GE3337@deprecation.cyrius.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Michlmayr <tbm@cyrius.com> wrote:

> I noticed that my network performance has gone down from 2.6.22
> from   [  3]  0.0-10.0 sec    113 MBytes  95.0 Mbits/sec
> to     [  3]  0.0-10.0 sec   75.7 MBytes  63.3 Mbits/sec
> with 2.6.23-rc1 (and 2.6.23-rc8), as measured with iperf.
> 
> I did a git bisect today and tracked it back to the commit where CFS
> was enabled ("sched: cfs core code; apply the CFS core code",
> commit dd41f596cda0d7d6e4a8b139ffdfabcefdd46528).  I also compiled a
> kernel from
> git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> but things don't improve.
> 
> This is on a Thecus N2100, an ARM (Intel IOP32x) based storage device 
> with a r8169 card, SATA disks and 512 MB RAM.  My config is attached.
> 
> What kind of information can I supply so you can track this down?

as a starter, could you boot the sched-devel.git kernel, with 
CONFIG_SCHED_DEBUG=y and CONFIG_SCHEDSTATS=y enabled and could you run 
this script while the iperf test is in the middle of its testrun:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

this will gather a good deal of info about the workload in question. 
Please send me the resulting debug file.

	Ingo

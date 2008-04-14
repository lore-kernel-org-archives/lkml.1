Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbYDNHSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbYDNHSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbYDNHSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:18:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbYDNHS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:18:29 -0400
Date: Mon, 14 Apr 2008 09:18:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Gautham Shenoy <ego@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.25-rc9 -- INFO: possible circular locking dependency
	detected
Message-ID: <20080414071800.GE16163@elte.hu>
References: <a44ae5cd0804132004v2bef54fek6e9634f8bce087ab@mail.gmail.com> <1208156045.7427.16.camel@twins> <20080414070234.GA7482@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414070234.GA7482@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Mon, Apr 14, 2008 at 08:54:05AM +0200, Peter Zijlstra wrote:
> > Fun,
> > 
> > I will need to sort out this code before I can say anything about that,
> > perhaps Gautham and or Rafael have ideas before I can come up with
> > something.. ?
> 
> Why not simply removing the get/put_online_cpus() pair in 
> sched_getaffinity? It's superfluous since we have already a 
> read_lock/read_unlock pair there which does disable/enable cpu hotplug 
> anyway.

we dont want to insert such silent "preempt off == hotplug disable" 
assumptions - which assumption breaks when the tasklist_lock becomes 
preemptible (such as in -rt).

	Ingo

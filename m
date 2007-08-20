Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbXHTTMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbXHTTMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbXHTTMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:12:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44353 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbXHTTMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:12:36 -0400
Date: Mon, 20 Aug 2007 21:12:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070820191208.GB3714@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <1187629438.8541.40.camel@localhost> <20070820180810.GA25160@elte.hu> <1187634782.4028.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187634782.4028.10.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> > If a virtual CPU is idle then i think the "real = steal, virtual = 
> > 0" way of thinking about idle looks a bit unnatural to me - wouldnt 
> > it be better to think in terms of "steal = 0, virtual = real" ? 
> > Basically a virtual CPU can idle at "perfect speed", without the 
> > host "stealing" any cycles from it. And with that way of thinking, 
> > if s390 passed in the real-idle-time value to the new callbacks 
> > below it would all fall into place. Hm?
> 
> How you think about an idle cpu depends on your viewpoint. The source 
> for the virtual cpu time on s390 is the cpu timer. This timer is 
> stopped when a virtual cpu looses the physical cpu, so it seems 
> natural to me to think that real=steal, virtual=0 because the cpu 
> timer is stopped while the cpu is idle. The other way of thinking 
> about it is as valid though.

my thinking is this: the structure of "idle time" only matters if it can 
be observed from "within" a virtual machine - via timers. Are on s390 
any of the typical app-visible timers (timer_list, etc.) driven by the 
virtual tick? [which slows down if a virtual CPU is scheduled away by 
the host/monitor/hypervisor?] Or is the virtual tick only affecting 
scheduling/cpu-accounting statistics in essence?

	Ingo

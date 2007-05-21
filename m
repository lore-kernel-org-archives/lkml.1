Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbXEUQBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbXEUQBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbXEUQBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:01:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56810 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbXEUQBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:01:44 -0400
Date: Mon, 21 May 2007 18:00:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: swap prefetch improvements
Message-ID: <20070521160029.GA28715@elte.hu>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200705121446.04191.kernel@kolivas.org> <20070521100320.GA1801@elte.hu> <200705212344.27511.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705212344.27511.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> > A suggestion for improvement: right now swap-prefetch does a small 
> > bit of swapin every 5 seconds and stays idle inbetween. Could this 
> > perhaps be made more agressive (optionally perhaps), if the system 
> > is not swapping otherwise? If block-IO level instrumentation is 
> > needed to determine idleness of block IO then that is justified too 
> > i think.
> 
> Hmm.. The timer waits 5 seconds before trying to prefetch, but then 
> only stops if it detects any activity elsewhere. It doesn't actually 
> try to go idle in between but it doesn't take much activity to put it 
> back to sleep, hence detecting yet another "not quite idle" period and 
> then it goes to sleep again. I guess the sleep interval can actually 
> be changed as another tunable from 5 seconds to whatever the user 
> wanted.

there was nothing else running on the system - so i suspect the swapin 
activity flagged 'itself' as some 'other' activity and stopped? The 
swapins happened in 4 bursts, separated by 5 seconds total idleness.

	Ingo

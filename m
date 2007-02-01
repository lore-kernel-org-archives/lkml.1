Return-Path: <linux-kernel-owner+w=401wt.eu-S1422679AbXBAIiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422679AbXBAIiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 03:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422689AbXBAIiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 03:38:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58098 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422679AbXBAIiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 03:38:24 -0500
Date: Thu, 1 Feb 2007 09:36:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070201083611.GC18233@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4992]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zach Brown <zach.brown@oracle.com> wrote:

> This patch introduces the notion of a 'fibril'.  It's meant to be a 
> lighter kernel thread. [...]

as per my other email, i dont really like this concept. This is the 
killer:

> [...]  There can be multiple of them in the process of executing for a 
> given task_struct, but only one can every be actively running at a 
> time. [...]

there's almost no scheduling cost from being able to arbitrarily 
schedule a kernel thread - but there are /huge/ benefits in it.

would it be hard to redo your AIO patches based on a pool of plain 
simple kernel threads?

We could even extend the scheduling properties of kernel threads so that 
they could also be 'companion threads' of any given user-space task. 
(i.e. they'd always schedule on the same CPu as that user-space task)

I bet most of the real benefit would come from co-scheduling them on the 
same CPU. But this should be a performance property, not a basic design 
property. (And i also think that having a limited per-CPU pool of AIO 
threads works better than having a per-user-thread pool - but again this 
is a detail that can be easily changed, not a fundamental design 
property.)

	Ingo

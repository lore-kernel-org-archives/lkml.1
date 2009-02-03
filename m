Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZBCMMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZBCMMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZBCMMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:12:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39457 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZBCMMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:12:19 -0500
Date: Tue, 3 Feb 2009 13:11:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>, Mike Travis <travis@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: mm-commits@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: +
	work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
	added to -mm tree
Message-ID: <20090203121147.GB19979@elte.hu>
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902031058.n13AwOoK016719@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> ------------------------------------------------------
> Subject: work_on_cpu(): rewrite it to create a kernel thread on demand
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> The various implemetnations and proposed implemetnations of work_on_cpu()
> are vulnerable to various deadlocks because they all used queues of some
> form.
> 
> Unrelated pieces of kernel code thus gained dependencies wherein if one
> work_on_cpu() caller holds a lock which some other work_on_cpu() callback
> also takes, the kernel could rarely deadlock.
> 
> Fix this by creating a short-lived kernel thread for each work_on_cpu()
> invokation.
> 
> This is not terribly fast, but the only current caller of work_on_cpu() is
> pci_call_probe().

hm, it's quite ugly as well, and wasteful with resources.

	Ingo

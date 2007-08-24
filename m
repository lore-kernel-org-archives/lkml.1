Return-Path: <linux-kernel-owner+w=401wt.eu-S1764627AbXHXGEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764627AbXHXGEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 02:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbXHXGEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 02:04:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34831 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbXHXGEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 02:04:15 -0400
Date: Fri, 24 Aug 2007 08:04:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Reduce overhead in balance_tasks()
Message-ID: <20070824060403.GB24742@elte.hu>
References: <46C2842E.3010806@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C2842E.3010806@bigpond.net.au>
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


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> At the moment, balance_tasks() provides low level functionality for 
> both
>  move_tasks() and move_one_task() (indirectly) via the load_balance() 
> function (in the sched_class interface) which also provides dual 
> functionality.  This dual functionality complicates the interfaces and 
> internal mechanisms and makes the run time overhead of operations that 
> are called with two run queue locks held.
> 
> This patch addresses this issue and reduces the overhead of these 
> operations.

hm, i like it, and added it to my queue (probably .24 material though), 
but note that it increases .text and .data overhead:

   text    data     bss     dec     hex filename
  41028   37794    2168   80990   13c5e sched.o.before
  41349   37826    2168   81343   13dbf sched.o.after

is that expected?

	Ingo

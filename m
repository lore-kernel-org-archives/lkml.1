Return-Path: <linux-kernel-owner+w=401wt.eu-S2992790AbXDDJkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992790AbXDDJkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992793AbXDDJkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:40:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44672 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992790AbXDDJkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:40:08 -0400
Date: Wed, 4 Apr 2007 11:39:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Paul Jackson <pj@sgi.com>
Subject: Re: getting processor numbers
Message-ID: <20070404093948.GA14521@elte.hu>
References: <461286D6.2040407@redhat.com> <20070403131623.c6831607.akpm@linux-foundation.org> <4612BB89.8040102@redhat.com> <20070403141348.9bcdb13e.akpm@linux-foundation.org> <4612D175.30604@redhat.com> <20070403154831.37bde672.akpm@linux-foundation.org> <4612DCA2.2090400@redhat.com> <20070403162349.583adf84.akpm@linux-foundation.org> <20070404083927.GA100@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404083927.GA100@tv-sign.ru>
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


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> But we don't need tasklist_lock at all, we can use 
> rcu_read_lock/unlock. Q: don't we need task_rq_lock() to read 
> ->cpus_allowed "atomically" ?

right now ->cpus_allowed is protected by tasklist_lock. We cannot do RCU 
here because ->cpus_allowed modifications are not RCUified.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbYBZKuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbYBZKuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYBZKuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:50:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46955 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbYBZKuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:50:11 -0500
Date: Tue, 26 Feb 2008 11:49:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Pavel Roskin <proski@gnu.org>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] mmiotrace full patch, preview 1
Message-ID: <20080226104948.GA32659@elte.hu>
References: <20080224190323.77adf683@daedalus.pq.iki.fi> <20080225144922.ae716e7d.akpm@linux-foundation.org> <20080225233449.GA25448@infradead.org> <20080226102149.GE20322@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226102149.GE20322@shadowen.org>
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


* Andy Whitcroft <apw@shadowen.org> wrote:

> Ok, so that would be the following, work for everyone?
> 
> WARNING: mutexes are preferred for single holder semaphores
> #1: FILE: Z95.c:1:
> +       DECLARE_MUTEX(&foo);
> 
> WARNING: mutexes are preferred for single holder semaphores
> #3: FILE: Z95.c:3:
> +       init_MUTEX(&foo);

yeah.

  Acked-by: Ingo Molnar <mingo@elte.hu>

also i guess init_MUTEX_LOCKED() should emit a "this should be a 
completion" warning.

i guess non-DEFINE_SPINLOCK old-style spinlock definition:

  spinlock_t lock = SPIN_LOCK_UNLOCKED;

should emit a 'use DEFINE_SPINLOCK' warning as well?

	Ingo

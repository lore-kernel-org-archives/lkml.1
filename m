Return-Path: <linux-kernel-owner+w=401wt.eu-S934425AbYD1NO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425AbYD1NO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934104AbYD1NN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:13:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50781 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934289AbYD1NN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:13:58 -0400
Date: Mon, 28 Apr 2008 15:13:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: missing locking in sched_domains code
Message-ID: <20080428131332.GA3723@elte.hu>
References: <20080427183926.acb66fff.akpm@linux-foundation.org> <20080428070946.GA4507@osiris.boeblingen.de.ibm.com> <20080428002853.1693e7fd.akpm@linux-foundation.org> <20080428075253.GB4507@osiris.boeblingen.de.ibm.com> <20080428081129.GC4507@osiris.boeblingen.de.ibm.com> <20080428083222.GA16963@elte.hu> <20080428084904.GA27056@osiris.boeblingen.de.ibm.com> <20080428015723.e1632c45.akpm@linux-foundation.org> <20080428091745.GB27056@osiris.boeblingen.de.ibm.com> <20080428093307.GC27056@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428093307.GC27056@osiris.boeblingen.de.ibm.com>
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

> > version 42. Please feel free to change the comment if you think it could
> > be better :)
> 
> I don't believe this... version 43 ;) I forgot to add the lock in 
> sched_init_smp(). Not that it would really matter, but it should be 
> there to avoid (even more) confusion.

hey i just had to iterate it to version 44.

this bit:

> -/* doms_cur_mutex serializes access to doms_cur[] array */
> -static DEFINE_MUTEX(doms_cur_mutex);
> +/* sched_domains_mutex serializes calls to arch_init_sched_domains,
> + * detach_destroy_domains and partition_sched_domains.
> + */
> +static DEFINE_MUTEX(sched_domains_mutex);

was inside an #ifdef section ;-)

	Ingo

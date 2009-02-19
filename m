Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZBSLHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZBSLHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZBSLHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:07:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55402 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZBSLHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:07:35 -0500
Date: Thu, 19 Feb 2009 12:07:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
Message-ID: <20090219110718.GK2354@elte.hu>
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499CA834.4080208@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499CA834.4080208@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Tejun Heo wrote:
> >   One trick we can do is to reserve the initial chunk in non-vmalloc
> >   area so that at least the static cpu ones and whatever gets
> >   allocated in the first chunk is served by regular large page
> >   mappings.  Given that those are most frequent visited ones, this
> >   could be a nice compromise - no noticeable penalty for usual cases
> >   yet allowing scalability for unusual cases.  If this is something
> >   which can be agreed on, I'll pursue this.
> 
> I've given more thought to this and it actually will solve 
> most of issues for non-NUMA but it can't be done for NUMA.  
> Any better ideas?

It could be allocated via NUMA-aware bootmem allocations.

	Ingo

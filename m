Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYKYPAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYKYPAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYKYPA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:00:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58849 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYKYPA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:00:26 -0500
Date: Tue, 25 Nov 2008 15:59:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: suparna@in.ibm.com, Zach Brown <zach.brown@oracle.com>,
       linux-aio@kvack.org, Jeff Moyer <jmoyer@redhat.com>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kvm aio wishlist
Message-ID: <20081125145949.GD14147@elte.hu>
References: <492B0CDD.7080000@redhat.com> <492B2348.9090008@oracle.com> <492B2976.3010209@redhat.com> <492B3912.3030707@oracle.com> <492BC5CB.6000609@redhat.com> <20081125101923.GA28123@in.ibm.com> <492BD807.4000002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492BD807.4000002@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> Perhaps a variant of syslet, that is kernel-only, and does:
>
> - always allocate a new kernel stack at io_submit() time, but not a 
>   new thread

such a N:M threading design is a loss - sooner or later we arrive to a 
point where people actually start using it and then we want to 
load-balance and schedule these entities.

So i'd suggest the kthread based async engine i wrote for syslets. It 
worked well and for kernel-only entities it schedules super-fast - it 
can do up to 20 million events per second on a 16-way box i'm testing 
on. The objections about syslets were not related to the scheduling of 
it but were mostly about the userspace API/ABI: you dont have to use 
that.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760562AbZANHvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbZANHvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZANHvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:51:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42565 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbZANHve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:51:34 -0500
Date: Wed, 14 Jan 2009 08:51:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, travis@sgi.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: fix broken flush_tlb_others_ipi()
Message-ID: <20090114075126.GA17562@elte.hu>
References: <20090114024303.GB1290@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114024303.GB1290@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> This commit broke flush_tlb_others_ipi() causing boot hangs on a
> 16 logical cpu system.
> 
> >	commit 4595f9620cda8a1e973588e743cf5f8436dd20c6
> >	Author: Rusty Russell <rusty@rustcorp.com.au>
> >	Date:   Sat Jan 10 21:58:09 2009 -0800
> >
> >	    x86: change flush_tlb_others to take a const struct cpumask
> 
> This change resulted in sending the invalidate tlb vector to the
> sender itself causing the hang. flush_tlb_others_ipi() should exclude
> the sender itself from the destination list.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

applied to tip/cpus4096, thanks Suresh!

	Ingo

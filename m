Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZBXIay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZBXIay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 03:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZBXIaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 03:30:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56654 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbZBXIap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 03:30:45 -0500
Date: Tue, 24 Feb 2009 09:30:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [2.6.28.7] BUG: using smp_processor_id() in preemptible
	[00000000] code: pageattr-test/207
Message-ID: <20090224083028.GA17355@elte.hu>
References: <49A2ECF5.80104@phoenixsoftware.de> <20090223151331.033e0bf5.akpm@linux-foundation.org> <49A343EE.20100@phoenixsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A343EE.20100@phoenixsoftware.de>
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


* Tilman Schmidt <t.schmidt@phoenixsoftware.de> wrote:

> On Mon, 23 Feb 2009 15:13:31 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> > A 2.6.28.6 -> 2.6.28.7 regressionlet.
> > 
> > This, I bet:
> > 
> > commit 2cf155b300c4839a7238b825c7c5f417e9d7cc68
> > Author: Jeremy Fitzhardinge <jeremy@goop.org>
> > Date:   Wed Feb 11 09:32:19 2009 -0800
> > 
> >     x86/cpa: make sure cpa is safe to call in lazy mmu mode
> >     
> >     commit 4f06b0436b2ddbd3b67b10e77098a6862787b3eb upstream.
> 
> Jackpot! Reverted that commit on 2.6.28.7, and the BUG messages are gone.

should be fixed by this as well:

d85cf93: x86/paravirt: make arch_flush_lazy_mmu/cpu disable preemption

	Ingo

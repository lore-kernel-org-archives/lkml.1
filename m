Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYHYR5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYHYR5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYHYR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:57:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51255 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbYHYR5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:57:30 -0400
Date: Mon, 25 Aug 2008 19:57:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@codemonkey.org.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] cpufreq: constant cpu_khz
Message-ID: <20080825175712.GA10848@elte.hu>
References: <1219646032.20732.10.camel@twins> <1219664106.8515.50.camel@twins> <20080825123926.GC8663@elte.hu> <20080825175547.GA26131@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825175547.GA26131@codemonkey.org.uk>
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


* Dave Jones <davej@codemonkey.org.uk> wrote:

>  > hm, that too is due to the tsc.c unification - Alok Cc:-ed. Applied 
>  > your fix to x86/urgent.
> 
> ACKed-by: Dave Jones <davej@redhat.com>
> 
> Good catch Peter.  I'm puzzled how that bug was latent on 64bit for so 
> long with no-one realising though.

i think it's the combination of these two factors:

 - bootup frequently is typically full-speed, so we calibrate things 
   right

 - cpufreq events are relatively slow-scale - and when they trigger the 
   system is definitely not under load. So how precisely the scheduler 
   functions isnt all that important in such scenarios - there's tons of
   CPU power available.

but it's indeed nice to have this fixed, and i just pushed the fix to 
Linus.

	Ingo

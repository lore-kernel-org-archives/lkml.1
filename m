Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbZHROAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbZHROAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZHROAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:00:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50892 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZHROAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:00:37 -0400
Date: Tue, 18 Aug 2009 16:00:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Message-ID: <20090818140022.GB13013@elte.hu>
References: <20090808120315.GA14086@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com> <20090810134608.GA8295@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com> <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins> <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com> <1250602664.7583.293.camel@twins> <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> Well, that would push out the limit a bit, but it would still be 
> quite fragile.
> 
> Currently, I'm not sure that this (i.e. that the interrupt 
> handling takes too long) is the underlying problem of the hangs 
> that I'm seeing.

I havent seen a plausible theory yet about why an actual lockup 
would happen on your box.

Does the timer IRQ perhaps slow down to such a degree that it can 
never make progress and gets re-triggered again and again? We saw 
such things with the function tracer.

Did the sampling of kernel-mode tasks ever work with the old BTS 
code?

	Ingo

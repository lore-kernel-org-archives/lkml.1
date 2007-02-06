Return-Path: <linux-kernel-owner+w=401wt.eu-S1750860AbXBFMia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750860AbXBFMia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbXBFMia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:38:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbXBFMi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:38:29 -0500
Date: Tue, 6 Feb 2007 13:37:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John <shill@free.fr>
Cc: linux-kernel@vger.kernel.org, tglx@timesys.com, johnstul@us.ibm.com,
       akpm@osdl.org
Subject: Re: One-shot high-resolution POSIX timer periodically late
Message-ID: <20070206123716.GA8481@elte.hu>
References: <fa.4zD54Ie6Ozt0P4YqQSicS+XzXGw@ifi.uio.no> <fa.G+/T32f2o1M3+YGLca/O8NaAQyY@ifi.uio.no> <fa.6Ua8xjNfLKQEZZgDsoJgPMyww4g@ifi.uio.no> <fa.yQlV+WU0TgrJTVqjopa01tgCnT0@ifi.uio.no> <fa.ucVrLJ1Lh6FjdBHRglsIUc8/evk@ifi.uio.no> <fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no> <45C1BE5C.9050001@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C1BE5C.9050001@free.fr>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4950]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* John <shill@free.fr> wrote:

> > 2.6.18-rt7 is pretty old, do you see the problem in 2.6.20-rc6-rt5 
> > too?
> 
> Ingo, Thomas,
> 
> I cannot reproduce in 2.6.20-rc6-rt6, but it is not strictly an 
> apples-to-apples comparison because I get a tsc clocksource in 
> 2.6.20-rc6-rt6, and an acpi_pm clocksource in 2.6.18.6-rt7.

that suggests that the TSC was not deemed reliable by the newer kernel - 
which almost always means it's not realiable. I think the problems you 
were seeing are consistent with TSC being non-monotonic - so the fix is 
to not use the TSC - and the newer kernel does this automatically.

	Ingo

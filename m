Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbXLYI01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbXLYI01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 03:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbXLYI0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 03:26:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59264 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbXLYI0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 03:26:17 -0500
Date: Tue, 25 Dec 2007 09:25:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: travis@sgi.com, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, Yinghai.Lu@Sun.COM
Subject: Re: volanoMark 24% regression in 2.6.24-rc6: why a simple patch
	makes it
Message-ID: <20071225082556.GA26342@elte.hu>
References: <1198559645.6362.195.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198559645.6362.195.camel@ymzhang>
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


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> The solution is just to revert patch 
> fbdcf18df73758b2e187ab94678b30cd5f6ff9f9, because other 2 patches 
> which fixed the same issue are already in 2.6.24-rc5.

Linus, please revert fbdcf18df73758, as requested by Yanmin. It was 
noticed before (by Yinghai Lu) that this commit was not needed, but it 
looked a harmless duplication and we incorrectly thought it's only a NOP 
and wanted to fix it in v2.6.25 - but as Yanmin has analyzed it now, it 
creates a sub-optimal sched-domains hierarchy (not setting up the domain 
belonging to the core) when CONFIG_X86_HT=y.

Acked-by: Ingo Molnar <mingo@elte.hu>

nice work Yanmin!

	Ingo

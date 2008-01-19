Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYASSqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYASSqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 13:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYASSqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 13:46:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41031 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYASSp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 13:45:59 -0500
Date: Sat, 19 Jan 2008 19:45:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: ACPI early ioremap problems
Message-ID: <20080119184543.GA3751@elte.hu>
References: <20080119030843.GA2028@basil.nowhere.org> <20080119150328.GA32370@elte.hu> <20080119152649.GA1375@one.firstfloor.org> <20080119153055.GA12054@elte.hu> <20080119154651.GA1626@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119154651.GA1626@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> On Sat, Jan 19, 2008 at 04:30:55PM +0100, Ingo Molnar wrote:
> > > > that case it's a 64-bit early_ioremap() bug that we want to find 
> > > > even if ACPI didnt use early_ioremap().
> > > > 
> > > > and this all runs before zap_low_mappings(), right?
> > > 
> > > No after. Since some time x86-64 does the equivalent of z_l_m() in 
> > > head64(); this means before start_kernel and definitely before 
> > > setup_arch which sets up ACPI.
> > 
> > that would mean early_ioremap() should switch to ioremap() after that 
> > point. Could you try that, does it resolve the failure you are seeing? 
> 
> ioremap() does alloc_page and that won't work before paging_init(). 
> Early ACPI scan is before paging_init() because paging_init() needs 
> node discovery at at least; which requires some ACPI tables.

hm, so are you saying that on 64-bit there's in essence no usable 
ioremap facility between zap_low_mappings() and paging_init()? 
(early_ioremap() is not usable anymore, and ioremap() is not yet 
usable.) I guess we'll have to pick up the 32-bit early_ioremap() code 
for 64-bit as well.

	Ingo

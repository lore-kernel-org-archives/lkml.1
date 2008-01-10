Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYAJK57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYAJK57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYAJK5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:57:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46145 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbYAJK5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:57:50 -0500
Date: Thu, 10 Jan 2008 11:57:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110105726.GD28209@elte.hu>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de> <20080110100443.GB28209@elte.hu> <20080110100712.GO25945@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110100712.GO25945@bingen.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> > > >   WBINVD isnt particular fast (takes a few msecs), but why is 
> > > >   that a problem? Drivers dont do high-frequency ioremap-ing. 
> > > >   It's typically only done at driver/device startup and that's 
> > > >   it.
> > > 
> > > Actually graphics drivers can do higher frequency allocation of WC 
> > > memory (with PAT) support.
> > 
> > but that's not too smart: why dont they use WB plus cflush instead?
> 
> Because they need to access it WC for performance.

I think you have it fundamentally backwards: the best for performance is 
WB + cflush. What would WC offer for performance that cflush cannot do?

also, it's irrelevant to change_page_attr() call frequency. Just map in 
everything from the card and use it. In graphics, if you remap anything 
on the fly and it's not a slowpath you've lost the performance game even 
before you began it.

	Ingo

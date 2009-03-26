Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZCZJ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZCZJ72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZCZJ7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:59:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbZCZJ7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:59:17 -0400
Date: Thu, 26 Mar 2009 10:58:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: fenghua.yu@intel.com, amluto@gmail.com, kyle@redhat.com,
       mgross@linux.intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [patch 1/2] Intel IOMMU Suspend/Resume Support for DMAR
Message-ID: <20090326095844.GC19826@elte.hu>
References: <20090325184548.012018000@intel.com> <20090325184635.374969000@intel.com> <20090325201228.GA26204@elte.hu> <1238024827.2085.60.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238024827.2085.60.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2009-03-25 at 21:12 +0100, Ingo Molnar wrote:
> > 
> > > +static int iommu_resume(struct sys_device *dev)
> > > +{
> > > +     struct dmar_drhd_unit *drhd;
> > > +     struct intel_iommu *iommu;
> > > +     unsigned long flag;
> > > +     int i = 0;
> > > +
> > > +     if (init_iommu_hw())
> > > +             panic("IOMMU setup failed, DMAR can not start!\n");
> > 
> > Please dont panic boxes ... insert a WARN() and return.
> 
> Well, the box is going to die anyway. If it was using the IOMMU 
> before suspend, and you fail to re-initialise the IOMMU after 
> resume, then you're buggered.

except if one is testing suspend/resume (via pm-test) without 
actually suspending the hardware.

> But if you panic() immediately during the resume, the message is 
> unlikely to make it out even to a serial console. If you print a 
> warning and limp on, I suppose there's at least a _chance_ that it 
> might get seen.

yeah.

	Ingo

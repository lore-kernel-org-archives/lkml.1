Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZCYXrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZCYXrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZCYXra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:47:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:36514 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbZCYXr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:47:29 -0400
Subject: Re: [patch 1/2] Intel IOMMU Suspend/Resume Support for DMAR
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: fenghua.yu@intel.com, amluto@gmail.com, kyle@redhat.com,
       mgross@linux.intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
In-Reply-To: <20090325201228.GA26204@elte.hu>
References: <20090325184548.012018000@intel.com>
	 <20090325184635.374969000@intel.com>  <20090325201228.GA26204@elte.hu>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 23:47:07 +0000
Message-Id: <1238024827.2085.60.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 21:12 +0100, Ingo Molnar wrote:
> 
> > +static int iommu_resume(struct sys_device *dev)
> > +{
> > +     struct dmar_drhd_unit *drhd;
> > +     struct intel_iommu *iommu;
> > +     unsigned long flag;
> > +     int i = 0;
> > +
> > +     if (init_iommu_hw())
> > +             panic("IOMMU setup failed, DMAR can not start!\n");
> 
> Please dont panic boxes ... insert a WARN() and return.

Well, the box is going to die anyway. If it was using the IOMMU before
suspend, and you fail to re-initialise the IOMMU after resume, then
you're buggered.

But if you panic() immediately during the resume, the message is
unlikely to make it out even to a serial console. If you print a warning
and limp on, I suppose there's at least a _chance_ that it might get
seen.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZDKCNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZDKCNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 22:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZDKCN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 22:13:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:46275 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZDKCN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 22:13:26 -0400
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
 enabled
From: David Woodhouse <dwmw2@infradead.org>
To: suresh.b.siddha@intel.com
Cc: Kyle McMartin <kyle@redhat.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Andrew Lutomirski'" <amluto@gmail.com>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "'Yinghai Lu'" <yinghai@kernel.org>,
       "'Mark Gross'" <mgross@linux.intel.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>
In-Reply-To: <1239410913.27006.8062.camel@localhost.localdomain>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com>
	 <20090324203259.GC26930@elte.hu>
	 <A6AD88C3F2289247BE726C37303E1EB8A04DB530@orsmsx505.amr.corp.intel.com>
	 <20090324204028.GE11771@kibblesnbits.boston.devel.redhat.com>
	 <1239403571.712.1228.camel@macbook.infradead.org>
	 <1239410913.27006.8062.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Apr 2009 19:12:52 -0700
Message-Id: <1239415972.712.1455.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 17:48 -0700, Suresh Siddha wrote:
> On Fri, 2009-04-10 at 15:46 -0700, David Woodhouse wrote:
> > On Tue, 2009-03-24 at 16:40 -0400, Kyle McMartin wrote:
> > > > Current kernel doesn't have iommu suspend/resume support yet. I'll
> > > > send out suspend/resume patches today or tomorrow. Hope that will
> > > > help. 
> > > 
> > > Heh, awesome, someone could have brought this, uhm, subtle, weakness
> > > when things were getting defaulted on...
> > 
> > git://git.infradead.org/~dwmw2/iommu-suspend-2.6.29.git
> > 
> > That's just for IOMMU, not interrupt remapping (yet).
> 
> Is this for 2.6.29-stable series? Is this really critical to have it for
> -stable?

I suspect not. We don't need it on Cantiga, and I think that's all we
really care about for 2.6.29-stable. Non-laptop chipsets, or laptop
chipsets that aren't actually out there in the wild yet, can wait for
2.6.30.

The less we have to backport, the better -- and suspend/resume support
for interrupt remapping would also require backporting a bunch of other
changes in the apic code.

At least what I have in the above tree so far is self-contained in the
VT-d code¹.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

¹ Conveniently forgetting the part where we change the definition of the
  if() macro...


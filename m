Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbZCMRPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbZCMRPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZCMRPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:15:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:49328 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041AbZCMRO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:14:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,358,1233561600"; 
   d="scan'208";a="394314306"
Subject: Re: remap_pfn_range() not suitable for physical RAM?
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Frank Mehnert <Frank.Mehnert@Sun.COM>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
In-Reply-To: <200903131600.00463.frank.mehnert@sun.com>
References: <200903042025.46861.frank.mehnert@sun.com>
	 <200903100904.22753.frank.mehnert@sun.com>
	 <7E82351C108FA840AB1866AC776AEC464FD82A88@orsmsx505.amr.corp.intel.com>
	 <200903131600.00463.frank.mehnert@sun.com>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 10:13:36 -0700
Message-Id: <1236964416.4529.125.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Frank,

The track and untrack is keeping track of memory type for non-RAM
regions and making sure that the type is in sync for various mappings
for such addresses. We are not tracking the RAM pages today, so
vm_insert_page does not have this. vm_insert_mixed is also not covered
today, as we deferred that and tracking of RAM pages into our next set
of changes.

Thanks,
Venki

On Fri, 2009-03-13 at 08:00 -0700, Frank Mehnert wrote:
> Venki,
> 
> thanks for your reply. May I ask anyway why this check is done in 
> remap_pfn_range() and vm_insert_pfn() but not in vm_insert_page()?
> 
> Kind regards,
> 
> Frank
> 
> On Tuesday 10 March 2009, Pallipadi, Venkatesh wrote:
> > Frank,
> >
> > Patch here should eliminate the restriction.
> > http://marc.info/?l=linux-kernel&m=123664923030126&w=1
> >
> > Thanks,
> > Venki
> >
> > >-----Original Message-----
> > >From: linux-kernel-owner@vger.kernel.org
> > >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Frank Mehnert
> > >Sent: Tuesday, March 10, 2009 1:04 AM
> > >To: linux-kernel@vger.kernel.org
> > >Cc: peterz@infradead.org; Siddha, Suresh B
> > >Subject: Re: remap_pfn_range() not suitable for physical RAM?
> > >
> > >Hi,
> > >
> > >sorry for re-posting this message and sorry for addressing you
> > >directly.
> > >Perhaps you can help me again or can you give me a pointer for a proper
> > >documentation of the various *remap* and *vm_insert* functions:
> > >
> > >On Wednesday 04 March 2009, Frank Mehnert wrote:
> > >> since 2.6.29-rcX it seems to be not allowed anymore to use
> > >> remap_pfn_range() to remap physical RAM to userland. This restriction
> > >> applies only if CONFIG_X86_PAT is enabled. It seems that
> > >
> > >vm_insert_page()
> > >
> > >> does not have this restriction. Am I correct? And what is the reason
> > >> for this restriction?
> > >
> > >Kind regards,
> > >
> > >Frank
> > >--
> > >Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/
> > >--
> >
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


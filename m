Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0CJCzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 21:55:31 -0500
Received: from mga07.intel.com ([143.182.124.22]:57822 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755180Ab0CJCz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 21:55:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,611,1262592000"; 
   d="scan'208";a="252828589"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV extension of HVM
Date: Wed, 10 Mar 2010 10:56:42 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Konrad Rzeszutek Wilk <kliw@darnok.org>
References: <1268032732-8025-1-git-send-email-sheng@linux.intel.com> <1268128085.11737.59761.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1003090954010.4869@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003090954010.4869@kaball-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003101056.42511.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 March 2010 18:22:31 Stefano Stabellini wrote:
> On Tue, 9 Mar 2010, Ian Campbell wrote:
> > On Tue, 2010-03-09 at 07:00 +0000, Jeremy Fitzhardinge wrote:
> > > On 03/08/2010 05:53 PM, Sheng Yang wrote:
> > > > On Tuesday 09 March 2010 01:10:56 Stefano Stabellini wrote:
> > > >> I think that mapping interrupts into VIRQs is a bad idea: you should
> > > >> map interrupts into pirqs instead, the code exists already on the
> > > >> kernel side so we don't need to do any (ugly) change ther.
> > > >
> > > > The code existed in the pv_ops dom0 side, but not in the upstream
> > > > Linux. The latter is our target. We want this work to be accepted by
> > > > upstream Linux soon.
> > >
> > >    2. It has significant overlaps with the current xen.git development
> > >       which is also targeted for upstream.  There's no point in
> > > creating an unnecessary duplicate mechanism when the infrastructure
> > > will be in place anyway.
> >
> > There's also nothing stopping us from upstreaming portions of the "dom0"
> > patchset ahead of full dom0 support if it is useful for some domU
> > feature.
> 
> Indeed.
> You just need the pirq mappings and few other things, it shouldn't be
> too hard.
> At this point I am going to do that myself after this patch series is
> completed.
 
I think we can leave the controversial thing later. At least, we want a 
framework for PV extension of HVM. We can work together to determine what is 
the better way for evtchn, as well as porting pirqs. (And the later MSI work 
may also depends on it)

But I think the former 6 patches can be taken as the base. It won't overlapped 
with others. And PV clocksource is definitely important for HVM guest. We 
would like to get the first 6 ones checked in Linux upstream first, then we 
can work on others. And it would the work easier for us later.

So Jeremy, how about a even more simplified version only contained framework 
and pv clocksource? I think it's pretty elegant and solid first step into 
Linux upstream.

If you agree, I would send the updated patchset soon, only framework and pv 
clocksource.

-- 
regards
Yang, Sheng

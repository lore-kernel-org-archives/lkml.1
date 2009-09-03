Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZICQDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZICQDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbZICQDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:03:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:51656 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732AbZICQDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:03:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,325,1249282800"; 
   d="scan'208";a="490229009"
From: "Luck, Tony" <tony.luck@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Luming Yu <luming.yu@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>, Felix Blyakher <felixb@sgi.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, Bob Picco <bob.picco@hp.com>
Date: Thu, 3 Sep 2009 09:02:52 -0700
Subject: RE: [RFC PATCH] Add TRACE_IRQFLAGS_SUPPORT, LOCKDEP_SUPPORT then
 enable ftrace for ia64
Thread-Topic: [RFC PATCH] Add TRACE_IRQFLAGS_SUPPORT, LOCKDEP_SUPPORT then
 enable ftrace for ia64
Thread-Index: AcoscxAX4xrUMNQwRNqXR+ofRclicwAPCJmw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E038E14B@orsmsx505.amr.corp.intel.com>
References: <3877989d0908272018va6ee8f7n7ab2838fdf1b26e6@mail.gmail.com>
	 <20090828062212.GB11552@elte.hu>
	 <57C9024A16AD2D4C97DC78E552063EA3E038DE7E@orsmsx505.amr.corp.intel.com>
 <1251967590.7447.0.camel@twins>
In-Reply-To: <1251967590.7447.0.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > #ifdef CONFIG_LOCKDEP
> > #define PERCPU_PAGE_SHIFT 20 /* Need a Megabyte for lockdep */
> > #else
> > #define PERCPU_PAGE_SHIFT 16 /* 64K should be enough for normal use */
> > #endif
> 
> Hmm, isn't all that percpu stuff in a special section, who's size you
> can query at boot time and set-up accordingly?

The size is a build time parameter (must match with a supported TLB page
size for ia64 ... i.e. even power of two ... so 64K, 256K, 1M, 4M are all
possible, but 128K, 512K, 2M, ... are not).

Any code that includes the right header files can look at PERCPU_PAGE_SHIFT
(or PERCPU_PAGE_SIZE) and make decisions about things.  But in the
lockdep case the extra percpu space is statically allocated, so the special
section overflows and results in a build failure.

-Tony




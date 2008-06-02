Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbYFBR6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbYFBR6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYFBR6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:58:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:56433 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbYFBR6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:58:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,578,1204531200"; 
   d="scan'208";a="335048019"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [patch 01/41] cpu_alloc: Increase percpu area size to 128k
Date: Mon, 2 Jun 2008 10:58:17 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC0177822B@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080530040010.806208523@sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 01/41] cpu_alloc: Increase percpu area size to 128k
Thread-Index: AcjCCaxS8MOkmh28T3SXEj23jssv7gC0CzJA
References: <20080530035620.587204923@sgi.com> <20080530040010.806208523@sgi.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Christoph Lameter" <clameter@sgi.com>, <akpm@linux-foundation.org>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Mike Travis" <travis@sgi.com>
X-OriginalArrivalTime: 02 Jun 2008 17:58:17.0969 (UTC) FILETIME=[3CA91E10:01C8C4DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The per cpu allocator requires more per cpu space and we are already near
> the limit on IA64. Increase the maximum size of the IA64 per cpu area from
> 64K to 128K.

> -#define PERCPU_PAGE_SHIFT	16	/* log2() of max. size of per-CPU area */
> +#define PERCPU_PAGE_SHIFT	17	/* log2() of max. size of per-CPU area */

Don't you need some more changes to the alt_dtlb_miss handler in
ivt.S for this to work?  128K is not a supported pagesize on any
processor model.

-Tony

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZHNVmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZHNVmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZHNVmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:42:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:46948 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbZHNVmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:42:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,382,1246863600"; 
   d="scan'208";a="439113555"
From: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>
CC: Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Date: Fri, 14 Aug 2009 14:42:10 -0700
Subject: RE: [RFC] respect the referenced bit of KVM guest pages?
Thread-Topic: [RFC] respect the referenced bit of KVM guest pages?
Thread-Index: AcocxMpfxoxn/p0dQu6QW+i0Fm6N9gAYtW0w
Message-ID: <9EECC02A4CC333418C00A85D21E89326B6611AC5@azsmsx502.amr.corp.intel.com>
References: <20090812074820.GA29631@localhost> <4A82D24D.6020402@redhat.com>
 <20090813010356.GA7619@localhost> <4A843565.3010104@redhat.com>
 <4A843B72.6030204@redhat.com> <4A843EAE.6070200@redhat.com>
 <4A846581.2020304@redhat.com> <20090813211626.GA28274@cmpxchg.org>
 <4A850F4A.9020507@redhat.com> <20090814091055.GA29338@cmpxchg.org>
 <20090814095106.GA3345@localhost>
In-Reply-To: <20090814095106.GA3345@localhost>
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

A side note - I've been doing some tracing and shrink_active_list is called a humongous number of times (25000-ish during a ~90 kvm run), with a net result of zero pages moved nearly all the time.  Your test is rescuing essentially all candidate pages from the inactive list.  Right now, I have the VM_EXEC || PageAnon version of your test.

						Jeff

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763059AbYCSUFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763059AbYCSUFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYCSTi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:16659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbYCSTiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,521,1199692800"; 
   d="scan'208";a="356905013"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Date: Tue, 18 Mar 2008 17:14:39 -0700
Message-ID: <DDF46CB71CB9D647A983FECACF09A886A8A6B5@orsmsx424.amr.corp.intel.com>
In-reply-to: <20080318094527.FF12.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Thread-Index: AciIkYiakqOu3vl0RtCANCkSZCkL+AAwgfaA
References: <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <DDF46CB71CB9D647A983FECACF09A886A33019@orsmsx424.amr.corp.intel.com> <20080318094527.FF12.KOSAKI.MOTOHIRO@jp.fujitsu.com>
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 19 Mar 2008 00:14:40.0492 (UTC) FILETIME=[397FAAC0:01C88956]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>this paramter mean use all physical memory and about 1GB swap space.
>Could you expand swap space?

We can reproduce the soft lockup issue now and root cause the issue as
well.

Since the ptc.g patch uses semaphore ptcg_sem to serialize multiple
ptc.g instructions in ia64_global_tlb_purge(). This requires the code
path should be safe to sleep in down(). But the code path can not sleep
during swap because it holds some spin locks (e.g. anon_vma_lock). Going
to sleep finally causes soft lockup.

Actually we though of this issue before releasing the ptcg patch and
wrote some non-sleeping versions of ptcg patches. But since we couldn't
see the sleeping issue during our testing, we didn't release a
non-sleeping ptcg patch. If replacing the ptcg patch in -mm1 tree with
one of our non-sleeping ptcg patches, the issue goes away.

Tony and I are working on releasing a final ptcg patch to solve the
issue.

Thanks.

-Fenghua

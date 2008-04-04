Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYDDXxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYDDXxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 19:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYDDXxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 19:53:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:14383 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbYDDXxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 19:53:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,606,1199692800"; 
   d="scan'208";a="267141942"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Date: Fri, 4 Apr 2008 16:52:29 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC01011FE8@orsmsx424.amr.corp.intel.com>
In-reply-to: <DDF46CB71CB9D647A983FECACF09A886A8A6B5@orsmsx424.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Thread-Index: AciIkYiakqOu3vl0RtCANCkSZCkL+AAwgfaAA1agksA=
References: <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <DDF46CB71CB9D647A983FECACF09A886A33019@orsmsx424.amr.corp.intel.com> <20080318094527.FF12.KOSAKI.MOTOHIRO@jp.fujitsu.com> <DDF46CB71CB9D647A983FECACF09A886A8A6B5@orsmsx424.amr.corp.intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 04 Apr 2008 23:52:30.0401 (UTC) FILETIME=[F1B9A310:01C896AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We can reproduce the soft lockup issue now and root cause the issue as
well.
>
> Since the ptc.g patch uses semaphore ptcg_sem to serialize multiple
> ptc.g instructions in ia64_global_tlb_purge(). This requires the code
> path should be safe to sleep in down(). But the code path can not
> sleep during swap because it holds some spin locks (e.g.
anon_vma_lock).
> Going to sleep finally causes soft lockup.

I've just pushed a new version of this patch into my test tree (so
it will show up in -mm and linux-next when they pull and rebuild).
It now uses the Piggin/Wilcox "spinaphore" primitives.  It passes
all my tests, and some runs of "hackbench" that tried to match the
tests that failed before at Fujitsu by forcing moderate amounts of
swapping.

-Tony

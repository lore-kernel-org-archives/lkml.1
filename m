Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYCTQE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYCTQE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 12:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYCTQEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 12:04:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:8615 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbYCTQEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 12:04:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,531,1199692800"; 
   d="scan'208";a="263847551"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish>12 hour
Date: Thu, 20 Mar 2008 09:04:08 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECDDA233@orsmsx424.amr.corp.intel.com>
In-reply-to: <1205969039.6437.44.camel@lappy>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish>12 hour
Thread-Index: AciKGMlRqIBxaagpRwyP1c64cnZO5AAigWug
References: <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <DDF46CB71CB9D647A983FECACF09A886A33019@orsmsx424.amr.corp.intel.com> <20080318094527.FF12.KOSAKI.MOTOHIRO@jp.fujitsu.com> <DDF46CB71CB9D647A983FECACF09A886A8A6B5@orsmsx424.amr.corp.intel.com> <1205969039.6437.44.camel@lappy>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "LKML" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 20 Mar 2008 16:04:09.0361 (UTC) FILETIME=[0800F810:01C88AA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which makes me wonder, why did you ever use a semaphore here? Looking at
> the code its a straight forward mutex. And when you would have used a
> mutex lockdep would have warned about this.

The functionality that we are trying to add is to allow up to N
simultaneous processors to execute the critical region.  On current
processors/platforms N=1 so a spinlock or mutex would be fine, but
there will be platforms for which N is a small integer greater than
one.  Semaphore initialized to N looked to be the ideal primitive
for this (until Motohiro-san ran the test case that showed the path
where we call this code with a spinlock held).

Next question is whether it is reasonable to get to this code
while holding a spinlock.  Isn't this a problem for architectures
that need to use cross-processor interrupts to do a global TLB
shootdown?

-Tony

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbYCTQRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbYCTQRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 12:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbYCTQRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 12:17:37 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:47564 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754068AbYCTQRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 12:17:36 -0400
X-SourceIP: 80.56.237.116
Subject: RE: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish>12
	hour
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECDDA233@orsmsx424.amr.corp.intel.com>
References: <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <DDF46CB71CB9D647A983FECACF09A886A33019@orsmsx424.amr.corp.intel.com>
	 <20080318094527.FF12.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <DDF46CB71CB9D647A983FECACF09A886A8A6B5@orsmsx424.amr.corp.intel.com>
	 <1205969039.6437.44.camel@lappy>
	 <1FE6DD409037234FAB833C420AA843ECDDA233@orsmsx424.amr.corp.intel.com>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 17:16:42 +0100
Message-Id: <1206029802.8514.406.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 09:04 -0700, Luck, Tony wrote:
> > Which makes me wonder, why did you ever use a semaphore here? Looking at
> > the code its a straight forward mutex. And when you would have used a
> > mutex lockdep would have warned about this.
> 
> The functionality that we are trying to add is to allow up to N
> simultaneous processors to execute the critical region.  On current
> processors/platforms N=1 so a spinlock or mutex would be fine, but
> there will be platforms for which N is a small integer greater than
> one.  Semaphore initialized to N looked to be the ideal primitive
> for this (until Motohiro-san ran the test case that showed the path
> where we call this code with a spinlock held).

Right, no alternative there.

> Next question is whether it is reasonable to get to this code
> while holding a spinlock.  Isn't this a problem for architectures
> that need to use cross-processor interrupts to do a global TLB
> shootdown?

Yeah, semaphores can't be used from hardirq contexts for much the same
reasons. But its all ia64 code, right? So I'm not directly seeing how
other archs are affected here.


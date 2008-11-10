Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYKJHf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYKJHf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYKJHfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:35:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54699 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYKJHfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:35:15 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATH -mm -v2] Fix a race condtion of oops_in_progress
Cc: kosaki.motohiro@jp.fujitsu.com, Chris Snook <csnook@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1225762877.27266.22.camel@yhuang-dev.sh.intel.com>
References: <490F468B.4040602@redhat.com> <1225762877.27266.22.camel@yhuang-dev.sh.intel.com>
Message-Id: <20081110163135.616E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 10 Nov 2008 16:35:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > As far as I know, barriers don't cause changes to be visible on other
> > > CPUs faster too. It just guarantees corresponding operations after will
> > > not get executed until that before have finished. And, I don't think we
> > > need make changes to be visible on other CPUs faster.
> > 
> > You're correct that barrier() has no impact on other CPUs.  wmb() and rmb() do. 
> >   If we don't need to make changes visible any faster, what's the point in using 
> > atomic_set()?  It's not any less racy.  atomic_inc() and atomic_dec() would be 
> > less racy, but you're not using those.
> 
> In default bust_spinlocks() implementation in lib/bust_spinlocks.c,
> atomic_inc() and atomic_dec_and_test() is used. Which is used by x86
> too. In some other architecture, atomic_set() is used to replace
> "oops_in_progress = <xxx>". So this patch fixes architectures which use
> default bust_spinlocks(), other architectures can be fixed by
> corresponding architecture developers.

I think Chris is right.
So, I reccomend to read Documentation/memory-barriers.txt

Almost architecture gurantee atomic_inc cause barrier implicitly.
but not _all_ architecture.




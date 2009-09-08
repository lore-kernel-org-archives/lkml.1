Return-Path: <linux-kernel-owner+w=401wt.eu-S1751094AbZIHP11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094AbZIHP11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 11:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbZIHP11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 11:27:27 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:16009 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZIHP10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 11:27:26 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [rfc] lru_add_drain_all() vs isolation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mm <linux-mm@kvack.org>, Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0909081110450.30203@V090114053VZO-1>
References: <20090908190148.0CC9.A69D9226@jp.fujitsu.com>
	 <1252405209.7746.38.camel@twins>
	 <20090908193712.0CCF.A69D9226@jp.fujitsu.com>
	 <1252411520.7746.68.camel@twins>
	 <alpine.DEB.1.10.0909081000100.15723@V090114053VZO-1>
	 <1252419602.7746.73.camel@twins>
	 <alpine.DEB.1.10.0909081110450.30203@V090114053VZO-1>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 17:27:16 +0200
Message-Id: <1252423637.7746.99.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 11:22 -0400, Christoph Lameter wrote:
> On Tue, 8 Sep 2009, Peter Zijlstra wrote:
> 
> > There is _no_ functional difference between before and after, except
> > less wakeups on cpus that don't have any __lru_cache_add activity.
> >
> > If there's pages on the per cpu lru_add_pvecs list it will be present in
> > the mask and will be send a drain request. If its not, then it won't be
> > send.
> 
> Ok I see.
> 
> A global cpu mask like this will cause cacheline bouncing. After all this
> is a hot cpu path. Maybe do not set the bit if its already set
> (which may be very frequent)? Then add some benchmarks to show that it
> does not cause a regression on a 16p box (Nehalem) or so?

Yeah, testing the bit before poking at is sounds like a good plan.

Unless someone feels inclined to finish this and audit the kernel for
more such places, I'll stick it on the ever growing todo pile.




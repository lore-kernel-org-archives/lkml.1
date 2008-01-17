Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYAQMH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYAQMH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYAQMHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:07:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58638 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbYAQMHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:07:17 -0500
Subject: Re: 2.6.24-rc7: memory leak?
From: Peter Zijlstra <peterz@infradead.org>
To: CaT <cat@zip.com.au>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080117114050.GR3940@zip.com.au>
References: <20080117063410.GQ3940@zip.com.au>
	 <1200568923.28661.9.camel@twins>  <20080117114050.GR3940@zip.com.au>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 13:07:12 +0100
Message-Id: <1200571632.28661.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 22:40 +1100, CaT wrote:
> On Thu, Jan 17, 2008 at 12:22:03PM +0100, Peter Zijlstra wrote:
> > On Thu, 2008-01-17 at 17:34 +1100, CaT wrote:
> > > cache). During the rsync the memory used grew to just shy of 1.6gig and
> > > now, about 2 hours after the rsync has well and truly finished, the used
> > > memory is at 1.23gig. This is what free reports:
> > > 
> > >              total       used       free     shared    buffers cached
> > > Mem:       2058128    1994468      63660          0     688604 11432
> > > -/+ buffers/cache:    1294432     763696
> > > Swap:      1048568          0    1048568
> > 
> > How much memory does:
> > 
> >   echo 3 > /proc/sys/vm/drop_caches
> > 
> > gain you?
> 
> 56M used now. 

Good :-)

> Should all this cache usage not be counted towards the
> 'Cached' entry in meminfo rather then getting counted as part of used
> ram. 

Cached is only the page-cache, not all the other caches we have..
This someones confuses people, but one gets used to it. slabinfo allows
one to easily view others.

> I assume that this would not cause an oom situation and would be
> freed up if all that memory really did need to be used.

Correct.



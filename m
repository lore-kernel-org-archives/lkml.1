Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbYENOut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbYENOut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761717AbYENOuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:50:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:38546 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760949AbYENOui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:50:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/wx/xYS47wZ/O1ei10hh5cfwLQ3GviSCKfzP/GcI
	hvl/se1jL/wotv
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: Mike Galbraith <efault@gmx.de>
To: vatsa@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <20080514134414.GA12693@linux.vnet.ibm.com>
References: <1210226013.3453.113.camel@ymzhang>
	 <20080508061125.GC3644@linux.vnet.ibm.com>
	 <20080509155240.GH3612@linux.vnet.ibm.com>
	 <1210556351.3151.2.camel@ymzhang>
	 <20080512023758.GN3612@linux.vnet.ibm.com>
	 <1210563200.3151.10.camel@ymzhang>
	 <20080512045246.GP3612@linux.vnet.ibm.com>
	 <1210568533.3151.13.camel@ymzhang>
	 <1210583090.7402.4.camel@marge.simson.net>
	 <1210584047.6524.12.camel@lappy.programming.kicks-ass.net>
	 <20080514134414.GA12693@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 16:50:33 +0200
Message-Id: <1210776633.5781.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-14 at 19:14 +0530, Srivatsa Vaddagiri wrote:
> On Mon, May 12, 2008 at 11:20:47AM +0200, Peter Zijlstra wrote:
> > It looks like things like find_busiest_group() just think everything is
> > peachy when the imbalance is < 1 task - which with all this grouping
> > stuff is not necessarily true.
> 
> fwiw, the following hack seems to help bring down regression to ~5%
> (b/n 2.6.25 and 2.6.26-rc1 with USER_SCHED):
> 
> Also in the patch GROUP_SCALE can probably be less than what I used (and
> needs a ifdef GROUP_SCHED) ..

On my little Q6600 with git.today, it made no real difference, whether
NORMALIZED_SLEEPERS was enabled or not.  I see roughly 10-15% idle time
w/wo this patch, whereas pre-regression, it's < 2%.

	-Mike


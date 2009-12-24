Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZLXEnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZLXEnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 23:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZLXEny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 23:43:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:47508 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752041AbZLXEnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 23:43:53 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19T6il7UhBTqki1SWsoGT0BFYJTh30Hoq/UfW57Ru
	JVqB61VRy/eEIy
Subject: Re: [PATCH 7/6][RFC] sched: unify load_balance{,_newidle}()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       SureshSiddha <suresh.b.siddha@intel.com>,
       "Pallipadi,Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <1261581216.4937.150.camel@laptop>
References: <20091217185021.684424629@chello.nl>
	 <1261581216.4937.150.camel@laptop>
Content-Type: text/plain
Date: Thu, 24 Dec 2009 05:43:44 +0100
Message-Id: <1261629824.10947.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 16:13 +0100, Peter Zijlstra wrote:
> load_balance() and load_balance_newidle() look remarkably similar, one
> key point they differ in is the condition on when to active balance.
> 
> So split out that logic into a separate function.
> 
> One side effect is that previously load_balance_newidle() used to fail and
> return -1 under these conditions, whereas now it doesn't. I've not yet fully
> figured out the whole -1 return case for either load_balance{,_newidle}().
> 
> It also differs in that sd->cache_nice_tries is now added on the 
> CPU_NEWLY_IDLE case.

Unification Looks like a good idea, less being more and all that.  I
suspect that last bit is why newidle effectiveness has been heavily
impacted.  x264 ultrafast testcase is whimpering pathetically again ;-)

	-Mike


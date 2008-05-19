Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYESGxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYESGxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 02:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYESGxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 02:53:12 -0400
Received: from mga06.intel.com ([134.134.136.21]:6991 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753687AbYESGxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 02:53:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,507,1204531200"; 
   d="scan'208";a="384989247"
Subject: Re: [Bug #10638] sysbench+mysql(oltp, readonly) 30% regression
	with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1211176540.8292.3.camel@twins>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.IMB.TtBMIB@albercik>
	 <1211131278.6463.7.camel@lappy.programming.kicks-ass.net>
	 <1211135856.6463.22.camel@lappy.programming.kicks-ass.net>
	 <1211160283.3177.134.camel@ymzhang>  <1211176540.8292.3.camel@twins>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 19 May 2008 14:49:27 +0800
Message-Id: <1211179767.3177.166.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-19 at 07:55 +0200, Peter Zijlstra wrote:
> On Mon, 2008-05-19 at 09:24 +0800, Zhang, Yanmin wrote:
> > On Sun, 2008-05-18 at 20:37 +0200, Peter Zijlstra wrote:
> > > On Sun, 2008-05-18 at 19:21 +0200, Peter Zijlstra wrote:
> > > > On Sun, 2008-05-18 at 13:13 +0200, Rafael J. Wysocki wrote:
> > > > > This message has been generated automatically as a part of a report
> > > > > of recent regressions.
> > > > > 
> > > > > The following bug entry is on the current list of known regressions
> > > > > from 2.6.25.  Please verify if it still should be listed.
> > > > > 
> > > > > 
> > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10638
> > > > > Subject		: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
> > > > > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > > > > Date		: 2008-05-07 4:55 (12 days old)
> > > > > References	: http://marc.info/?l=linux-kernel&m=121013681527052&w=2
> > > > > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > > > > Patch		: http://marc.info/?l=linux-kernel&m=121015292616802&w=2
> > > > > 
> > > > > 
> > > > 
> > > > Could people test this:
> > > > 
> > > > git://git.kernel.org/home/peterz/git/linux-2.6-sched.git/ v2.6.26-rc2-group-load-balance
> > > 
> > > Seems I got my own url wrong - the right one is:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git v2.6.26-rc2-group-load-balance
> > I used below command to clone your tree:
> > RSYNC_PROXY=proxy.sc.intel.com:911 git clone rsync://rsync.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git linux-2.6-sched
> > 
> > Got below errors:
> > @ERROR: Unknown module 'home'
> > rsync: connection unexpectedly closed (0 bytes received so far) [receiver]
> > rsync error: error in rsync protocol data stream (code 12) at io.c(359)
> > fatal: failed to unpack tree object HEAD
> > 
> > 
> > Would you like to create a patch against 2.6.26-rc3?
> 
> Index: linux-2.6/kernel/sched_clock.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_clock.c
> +++ linux-2.6/kernel/sched_clock.c
I tested it on 8-core stoakley.

1) volanoMark
Comparing with 2.6.26-rc1, 2.6.26-rc3+peter_sched_git_patch result has about 30% improvement, but it still has
about 27% regression than the one of 2.6.25.

2) sysbench+mysql(readonly oltp)
﻿Comparing with 2.6.26-rc2, 2.6.26-rc3+peter_sched_git_patch result has about 15% improvement, but it still has
about 15% regression than the one of 2.6.25.

-yanmin



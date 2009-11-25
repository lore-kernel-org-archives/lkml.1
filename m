Return-Path: <linux-kernel-owner+w=401wt.eu-S934167AbZKYBUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167AbZKYBUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 20:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934071AbZKYBUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 20:20:31 -0500
Received: from mga05.intel.com ([192.55.52.89]:19371 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933966AbZKYBUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 20:20:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,282,1257148800"; 
   d="scan'208";a="750138047"
Subject: Re: [MM] Make mm counters per cpu instead of atomic
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <alpine.DEB.2.00.0911240914190.14045@router.home>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
	 <1258440521.11321.32.camel@localhost> <1258443101.11321.33.camel@localhost>
	 <1258450465.11321.36.camel@localhost>
	 <alpine.DEB.1.10.0911171223460.20360@V090114053VZO-1>
	 <1258966270.29789.45.camel@localhost>
	 <alpine.DEB.2.00.0911230830300.26432@router.home>
	 <1259049753.29789.49.camel@localhost>
	 <alpine.DEB.2.00.0911240914190.14045@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 25 Nov 2009 09:23:01 +0800
Message-Id: <1259112181.29789.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 09:17 -0600, Christoph Lameter wrote:
> On Tue, 24 Nov 2009, Zhang, Yanmin wrote:
> 
> > > True.... We need to find some alternative to per cpu data to scale mmap
> > > sem then.
> > I ran lots of benchmarks such like specjbb2005/hackbench/tbench/dbench/iozone
> > /sysbench_oltp(mysql)/aim7 against percpu tree(based on 2.6.32-rc7) on a 4*8*2 logical
> > cpu machine, and didn't find big result difference between with your patch and without
> > your patch.
> 
> This affects loads that heavily use mmap_sem. You wont find too many
> issues in tests that do not run processes with a large thread count and
> cause lots of faults or uses of get_user_pages(). The tests you list are
> not of that nature.
sysbench_oltp(mysql) is kind of such workload. Both sysbench and mysql are
multi-threaded. 2 years ago, I investigated a scalability issue of such
 workload and found mysql causes frequent down_read(mm->mmap_sem). Nick changes
it to down_read to fix it.

But this workload doesn't work well with more than 64 threads because mysql has some
unreasonable big locks in userspace (implemented as a conditional spinlock in
userspace).

Yanmin



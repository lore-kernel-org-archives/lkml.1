Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbXKMIgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbXKMIgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 03:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbXKMIfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 03:35:53 -0500
Received: from mga10.intel.com ([192.55.52.92]:12537 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677AbXKMIfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 03:35:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,409,1188802800"; 
   d="scan'208";a="380653981"
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       aneesh.kumar@linux.vnet.ibm.com
In-Reply-To: <1194920362.20251.161.camel@ymzhang>
References: <1194601672.20251.60.camel@ymzhang>
	 <1194602064.6289.157.camel@twins>  <1194833640.20251.80.camel@ymzhang>
	 <1194860728.7179.6.camel@twins>  <1194861112.20251.124.camel@ymzhang>
	 <1194873980.7179.31.camel@twins>  <47386BC4.3050403@panasas.com>
	 <1194886100.9713.13.camel@twins>  <1194920362.20251.161.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Tue, 13 Nov 2007 16:34:32 +0800
Message-Id: <1194942872.20251.175.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-13 at 10:19 +0800, Zhang, Yanmin wrote:
> On Mon, 2007-11-12 at 17:48 +0100, Peter Zijlstra wrote:
> > On Mon, 2007-11-12 at 17:05 +0200, Benny Halevy wrote:
> > > On Nov. 12, 2007, 15:26 +0200, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > Single socket, dual core opteron, 2GB memory
> > > > Single SATA disk, ext3
> > > > 
> > > > 2.6.23.1-42.fc8 #1 SMP
> > > > 
> > > >           524288       4  225977  447461
> > > >           524288       4  232595  496848
> > > >           524288       4  220608  478076
> > > >           524288       4  203080  445230
> > > > 
> > > > 2.6.24-rc2 #28 SMP PREEMPT
> > > > 
> > > >           524288       4   54043   83585
> > > >           524288       4   69949  516253
> > > >           524288       4   72343  491416
> > > >           524288       4   71775  492653
> > 
> > 2.6.24-rc2 +
> >         patches/wu-reiser.patch
> >         patches/writeback-early.patch
> >         patches/bdi-task-dirty.patch
> >         patches/bdi-sysfs.patch
> >         patches/sched-hrtick.patch
> >         patches/sched-rt-entity.patch
> >         patches/sched-watchdog.patch
> >         patches/linus-ext3-blockalloc.patch
> > 
> >           524288       4  179657  487676
> >           524288       4  173989  465682
> >           524288       4  175842  489800
> > 
> > 
> > Linus' patch is the one that makes the difference here. So I'm unsure
> > how you bisected it down to:
> > 
> >   04fbfdc14e5f48463820d6b9807daa5e9c92c51f
> Originally, my test suite is just to pick up the result of first run. Your prior
> patch(speed up writeback ramp-up on clean systems) fixed an issue about first
> run result regression. So my bisect captured it.
> 
> However, late on, I found following run have different results. A moment ago,
> I retested 04fbfdc14e5f48463820d6b9807daa5e9c92c51f by:
> #git checkout 04fbfdc14e5f48463820d6b9807daa5e9c92c51f
> #make
> 
> Then, reverse your patch. It looks like 04fbfdc14e5f48463820d6b9807daa5e9c92c51f
> is not the root cause of following run regression. I will change my test suite to
> make it run for many times and do a new bisect.
> 
> > These results seem to point to
> > 
> >   7c9e69faa28027913ee059c285a5ea8382e24b5d
My new bisect captured 7c9e69faa28027913ee059c285a5ea8382e24b5d
which caused the regression of iozone following run (3rd/4th... run after mounting
the ext3 partition).

Peter,

Where could I download Linus new patches, especially patches/linus-ext3-blockalloc.patch?
I couldn't find it in my archives of LKML mails.

yanmin

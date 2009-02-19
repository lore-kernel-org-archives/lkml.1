Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbZBSNwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbZBSNwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758833AbZBSNuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:50:40 -0500
Received: from sh.osrg.net ([192.16.179.4]:44298 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759411AbZBSNui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:50:38 -0500
Date: Thu, 19 Feb 2009 22:49:44 +0900
To: rjw@sisk.pl
Cc: hias@horus.com, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       James.Bottomley@HansenPartnership.com
Subject: Re: [Bug #12612] hard lockup when interrupting cdda2wav
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200902172123.13052.rjw@sisk.pl>
References: <ROx6X68CGJG.A.NoH.m40lJB@chimera>
	<20090217171601.GA3351@horus.com>
	<200902172123.13052.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090219224910U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 19 Feb 2009 22:49:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 21:23:12 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday 17 February 2009, Matthias Reichl wrote:
> > The bug is still present in 2.6.28.5:
> > 
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.28.5-dbg #1
> > ---------------------------------------------
> > swapper/0 is trying to acquire lock:
> >  (&q->__queue_lock){.+..}, at: [<ffffffff8040e615>] blk_put_request+0x25/0x60
> > 
> > but task is already holding lock:
> >  (&q->__queue_lock){.+..}, at: [<ffffffff8040e4fa>] blk_end_io+0x5a/0xa0
> > 
> > other info that might help us debug this:
> > 1 lock held by swapper/0:
> >  #0:  (&q->__queue_lock){.+..}, at: [<ffffffff8040e4fa>] blk_end_io+0x5a/0xa0
> > 
> > stack backtrace:
> > Pid: 0, comm: swapper Not tainted 2.6.28.5-dbg #1
> > Call Trace:
> >  <IRQ>  [<ffffffff8026cd07>] __lock_acquire+0x1797/0x1930

There is a patch for this but it might take some time to push it into
mainline (I hope that James will move the pending sg fixes to
scsi-fixes tree but it might be too late):

http://marc.info/?l=linux-scsi&m=123436612119386&w=2

Sorry about that again.

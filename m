Return-Path: <linux-kernel-owner+w=401wt.eu-S1946773AbXBQPPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946773AbXBQPPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 10:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946786AbXBQPPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 10:15:13 -0500
Received: from www.osadl.org ([213.239.205.134]:36853 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946773AbXBQPPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 10:15:12 -0500
Subject: Re: Using sched_clock for mmio-trace
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andi Kleen <andi@firstfloor.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Jeff Muizelaar <jeff@infidigm.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070217145655.GA15662@one.firstfloor.org>
References: <20070216013024.GA32287@infidigm.net>
	 <y0mr6sq2hfj.fsf@ton.toronto.redhat.com> <p73fy95g99w.fsf@bingen.suse.de>
	 <20070216212630.GC27135@redhat.com>
	 <20070217145655.GA15662@one.firstfloor.org>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 16:19:58 +0100
Message-Id: <1171725598.30834.125.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 15:56 +0100, Andi Kleen wrote:
> > This is one of the reasons why we don't just use good old
> > do_gettimeofday(), since it takes locks and can lead to lock recursion
> > if parts of itself are probed.
> 
> do_gettimeofday doesn't take locks.
> 
> Only restriction is that you can't single step it with long 
> pauses between instructions.

Err, it uses read side of xtime lock, so you can not call it from a
place which write locks xtime lock.

	tglx



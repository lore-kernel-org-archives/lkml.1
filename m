Return-Path: <linux-kernel-owner+w=401wt.eu-S965650AbXDGJuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965650AbXDGJuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965709AbXDGJuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:50:44 -0400
Received: from www.osadl.org ([213.239.205.134]:34033 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965650AbXDGJun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:50:43 -0400
Subject: Re: [patch] high-res timers: UP resume fix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <20070407094705.GA20998@elte.hu>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	 <20070407082554.GA1943@elte.hu>
	 <1175935730.28263.510.camel@localhost.localdomain>
	 <200704071148.43136.rjw@sisk.pl>  <20070407094705.GA20998@elte.hu>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 11:51:12 +0200
Message-Id: <1175939472.28263.518.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 11:47 +0200, Ingo Molnar wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > We do in on_each_cpu() unconditionally. I missed that.
> > 
> > BTW, the on_each_cpu() in clock_was_set() is unnecessary, because 
> > timekeeping_resume() is always run on one CPU.
> 
> yes - but that's not the only place where we do clock_was_set(), and the 
> on_each_cpu() is necessary in every other case. So i think the right 
> solution was the patch i did: to split the resume functionality from the 
> clock_was_set() functionality.

Right, I reused it and just did not notice, that interrupts are enabled
unconditionally in on_each_cpu().

	tglx



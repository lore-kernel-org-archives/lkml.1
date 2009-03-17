Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbZCQBnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbZCQBnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 21:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbZCQBnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 21:43:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48028 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbZCQBng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 21:43:36 -0400
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesper Krogh <jesper@krogh.cc>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A6FEE2.90700@krogh.cc>
	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
	 <49A70B24.6090706@krogh.cc>
	 <1235685269.6811.11.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>
	 <1235766936.7402.5.camel@localhost.localdomain> <49AE9EA4.2080500@krogh.cc>
	 <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>
	 <1236220759.6863.7.camel@localhost.localdomain>
	 <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc>
	 <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain>
	 <49BD225C.4070305@krogh.cc>
	 <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain>
	 <49BD4B2D.7000501@krogh.cc>
	 <alpine.LFD.2.00.0903151146550.3131@localhost.localdomain>
	 <49BD5C7C.2060605@krogh.cc> <49BEA1AD.1090901@krogh.cc>
	 <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 18:43:28 -0700
Message-Id: <1237254208.7306.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 12:32 -0700, Linus Torvalds wrote:
> I also think I know why John reported this:
> 
> > Ingo, Thomas: On the hardware I'm testing the fast-pit calibration only
> > triggers probably 80-90% of the time. About 10-20% of the time, the
> > initial check to pit_expect_msb(0xff) fails (count=0), so we may need to
> > look more at this approach.
> 
> and the reason is that when we re-program the PIT, it will actually take 
> until the next timer edge (the incoming 1.1MHz timer) for the new values 
> to take effect. So before the first call to pit_expect_msb(), we should 
> make sure to delay for at least one PIT cycle. The simplest way to do that 
> is to simply read the PIT latch once, it will take about 2us.
> 
> So this patch fixes that too.
> 
> John, does that make the PIT calibration work reliably on your machine?

Yep, I haven't seen a failure with it so far. And it's the same net
effect change my earlier patch was doing (one extra read cycle) just
without all the conditionals, so it should be fine.

thanks
-john



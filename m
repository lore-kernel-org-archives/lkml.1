Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbXCKJPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbXCKJPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 05:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbXCKJPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 05:15:16 -0400
Received: from www.osadl.org ([213.239.205.134]:53877 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751895AbXCKJPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 05:15:14 -0400
Subject: Re: Use of absolute timeouts for oneshot timers
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Hecht <dhecht@vmware.com>, john stultz <johnstul@us.ibm.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45F35088.7020607@goop.org>
References: <45F33697.4000000@goop.org>
	 <1173568491.24738.1194.camel@localhost.localdomain>
	 <45F35088.7020607@goop.org>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 10:21:38 +0100
Message-Id: <1173604898.24738.1204.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 16:42 -0800, Jeremy Fitzhardinge wrote:
> Thomas Gleixner wrote:
> > It's simply enforced in NO_HZ, HIGHRES mode as we operate in absolute
> > time, which is read back from the clocksource, even if we use a relative
> > value for real hardware clock event devices to program the next event.
> > We calculate the delta between the absolute event and now. So we never
> > get an accumulating error.
> >
> > What problem are you observing ?
> 
> Actually, two things.  There was the unexpected pauses during boot,
> which is trivially fixable by not using the Xen periodic timer, and
> using the single-shot fallback.
> 
> But I'm making the more general observation that if you use an absolute
> rather than relative time to set the single-shot timeout, then you have
> to deal with a long-term cumulative drift between the kernel's monotonic
> time and the hypervisor's monotonic time.  This can happen even if your
> clocksource is derived directly from the hypervisor monotonic time,
> because running ntp will warp the kernel's time, and so it will drift
> with respect to the hypervisor clock.  You can only avoid this by 1) not
> allowing adjtime, or 2) making those same adjtime warps to the
> hypervisor time.  Neither of these is a good general solution.

Sigh, yes. Using a relative time for the next event is probably the
least ugly solution

	tglx




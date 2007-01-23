Return-Path: <linux-kernel-owner+w=401wt.eu-S933122AbXAWUbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbXAWUbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 15:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933125AbXAWUbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 15:31:07 -0500
Received: from www.osadl.org ([213.239.205.134]:42526 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933122AbXAWUbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 15:31:06 -0500
Subject: Re: [patch 1/3] Scheduled removal of SA_xxx interrupt flags
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070123120245.ec3b0772.akpm@osdl.org>
References: <20070114081905.135797900@inhelltoy.tec.linutronix.de>
	 <20070114081926.912658228@inhelltoy.tec.linutronix.de>
	 <20070123120245.ec3b0772.akpm@osdl.org>
Content-Type: text/plain
Date: Tue, 23 Jan 2007 21:31:18 +0100
Message-Id: <1169584278.21181.86.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-23 at 12:02 -0800, Andrew Morton wrote:
> > The name space cleanup of the interrupt request flags (SA_xxx -> IRQF_xxx)
> > left a 6 month grace period for the old deprecated flags. Remove them.
> 
> fwiw, I'll make this [patch 3/3], so the kernel compiles OK at each step.

Yup, should have thought about that.

> This is going to break a lot of external stuff.  We should have found a way
> to make usage of SA_* emit deprecated warnings (or _some_ warning) to warn
> people of impending doom.  But I can't immediately find a way of doing
> that.
> if we _can_ find a way of doing this, I suspect we'll need to do it, and
> give people another six months.  It's going to get ugly out there.  We
> shall see...

Ugly, but might work:

static inline unsigned int __deprecated __sa_shirq(void) { return IRQF_DISABLED; }
#define SA_SHIRQ	__sa_shirq()

	tglx



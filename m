Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab0BRKti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:49:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36018 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab0BRKtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:49:35 -0500
Subject: Re: [patch 4/5] xtime_lock: Convert to raw_seqlock
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20100217184155.882793970@linutronix.de>
References: <20100217183740.486724334@linutronix.de>
	 <20100217184155.882793970@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 11:49:28 +0100
Message-ID: <1266490168.26719.179.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 18:47 +0000, Thomas Gleixner wrote:
> 
> xtime_lock needs a raw_spinlock in preempt-rt. Convert it to
> raw_seqlock and fix up all users.
> 
s/raw_spinlock/raw_seqlock/ ?

Maybe add an explanation on _why_ -rt needs this for the uninformed
amongst us.

-rt switches to sleeping spinlocks, but since the vdso is basically
userspace it cannot schedule, hence we need to keep using actual
spinlocks (this is also the reason the vdso things must not call into
lockdep)


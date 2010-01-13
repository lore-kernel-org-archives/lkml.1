Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572Ab0AMWJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0AMWJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529Ab0AMWJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:09:16 -0500
Received: from www.tglx.de ([62.245.132.106]:42056 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414Ab0AMWJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:09:16 -0500
Date: Wed, 13 Jan 2010 23:08:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiaotian Feng <dfeng@redhat.com>
cc: linux-kernel@vger.kernel.org, Magnus Damm <damm@igel.co.jp>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH] clockevent: don't remove broadcast device when cpu is
 dead
In-Reply-To: <4B4D2678.5090601@redhat.com>
Message-ID: <alpine.LFD.2.00.1001132305280.6420@localhost.localdomain>
References: <1262834564-13033-1-git-send-email-dfeng@redhat.com> <alpine.LFD.2.00.1001121300190.6420@localhost.localdomain> <4B4D2678.5090601@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010, Xiaotian Feng wrote:
> On 01/12/2010 09:20 PM, Thomas Gleixner wrote:
> > On Thu, 7 Jan 2010, Xiaotian Feng wrote:
> > 
> > > Marc reported BUG during shutdown, after debugging, kernel is trying
> > > to remove a broadcast device which mode is CLOCK_EVT_MODE_ONESHOT.
> > > 
> > > The root cause for this bug is that in clockevents_notify,
> > > "cpumask_weight(dev->cpumask) == 1" is always true even if dev is a
> > 
> > Why is cpumask_weight(dev->cpumask) == 1 always true when we shutdown
> > a non boot cpu ?
> > 
> > The broadcast device is not a per cpu device and the cpumask should
> > not only contain the CPU which is shut down !
> 
> At least for hpet broadcast dev, it's dev->cpumask is only contain the CPU
> which it is initialized from.

Which is fundamentaly wrong and the root cause of the problem. I'll
have a look tomorrow morning when my brain is more awake than now.

> And for broadcast device, kernel is using tick_broadcast_mask not
> dev->cpumask, right?

No, tick_broadcast_mask is the bitmask which tells us which cpus get
the broadcast IPI.

Thanks,

	tglx

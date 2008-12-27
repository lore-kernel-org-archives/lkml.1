Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYL0OAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYL0OAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 09:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYL0OAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 09:00:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:34303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbYL0OAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 09:00:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TOBdmWR+k5RFLJ98fz/bTe9wAFY9Mf2BN0IUBauMd3pAODAJOCVmZ/KosTDs77pPiN
         tHFhMflVv6PGkseZglfNBI3cgZ6hcF2+TfbkbkBC6hunZmBC0WYj3A6d79a5nsecsWax
         VUCfgBiF4CJIKZDyGpnJ1pL8gfIfmKWzA9ToU=
Date: Sat, 27 Dec 2008 15:00:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hrtimer: increase clock min delta threshold while
	interrupt hanging
Message-ID: <20081227140032.GB5671@nowhere>
References: <494EEC60.4080708@gmail.com> <20081227105334.GJ14639@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227105334.GJ14639@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 11:53:34AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: avoid hanging on slow systems
> > 
> > While using the function graph tracer on a virtualized system, the 
> > hrtimer_interrupt can hang the system on an infinite loop. This can be 
> > caused on several situation where something intrusive is slowing the 
> > system (ie: tracing) and the next clock events to program are always 
> > before the current time. This patch implements a reasonable compromise. 
> > If such a situation is detected, we share the CPUs time in 1/4 to 
> > process the hrtimer interrupts. This is enough to let the system running 
> > without serious starvation.
> > 
> > It has been successfully tested under VirtualBox with 1000 HZ and 100 HZ 
> > with function graph tracer launched. On both cases, the clock events 
> > were increased until about 25 ms periodic ticks, which means 40 HZ.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  kernel/hrtimer.c |   30 +++++++++++++++++++++++++++++-
> >  1 files changed, 29 insertions(+), 1 deletions(-)
> 
> applied to tip/timers/hrtimers, thanks Frederic!


I will apply the comments that came along these reviews in a delta patch.
Note that I still wonder about false positive with a 5 loop check. I think
I will increase it to 10. This a more reasonable.

(I remember I had false positive but I'm not sure if that was because of early_printk
used for debugging. I didn't worry about it first, because I hadn't these false positive
on my last tests, just before I send this patch.)

> 
> Thomas, any objections/observations?
> 
> 	Ingo


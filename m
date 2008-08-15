Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYHOK2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYHOK2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYHOK17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:27:59 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:36523 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYHOK16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:27:58 -0400
Subject: Re: [PATCH 00/07] dyn_array/nr_irqs/sparse_irq support v10 - fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080815101927.GA4770@elte.hu>
References: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080815082735.GC4776@elte.hu>
	 <86802c440808150134x5bf005fmdcb0f557422af365@mail.gmail.com>
	 <20080815085120.GA18748@elte.hu> <20080815093546.GA9312@elte.hu>
	 <1218794430.10800.237.camel@twins>  <20080815101927.GA4770@elte.hu>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 12:28:04 +0200
Message-Id: <1218796084.10800.239.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-15 at 12:19 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Fri, 2008-08-15 at 11:35 +0200, Ingo Molnar wrote:
> > 
> > > looks wrong - it should be unconditional (i've done that via the patch 
> > > below). I dont remember why we made early_init_irq_lock_class() 
> > > dependent on CONFIG_TRACE_IRQFLAGS before. Peter, do you have any 
> > > memories?
> > 
> > Nope, git suggests I poke you about it.. :-)
> 
> muhaha - i dont even know that guy who did this sloppy commit 2 years 
> ago - "Ingo Molnar", or however he is called.
> 
> I believe my (mistaken) thinking would have been that desc->irq lockdep 
> class does not matter as long as we dont do irq-tracing. Which might 
> have been borderline correct then but is wrong now, for things like 
> lockstat?

/me pokes a bit at kconfig dependancies, and yes, it seems you're right
- lockstat doesn't require irq tracing..




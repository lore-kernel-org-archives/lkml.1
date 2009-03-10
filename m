Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZCJP1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZCJP1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZCJP1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:27:30 -0400
Received: from www.tglx.de ([62.245.132.106]:39677 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbZCJP13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:27:29 -0400
Date: Tue, 10 Mar 2009 16:26:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Free setup_irq() interrupt V2
In-Reply-To: <20090310150415.GL3850@elte.hu>
Message-ID: <alpine.LFD.2.00.0903101615540.29264@localhost.localdomain>
References: <20090310102459.23422.80761.sendpatchset@rx1.opensource.se> <alpine.LFD.2.00.0903101510040.29264@localhost.localdomain> <20090310150415.GL3850@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Magnus,
> > 
> > On Tue, 10 Mar 2009, Magnus Damm wrote:
> > > From: Magnus Damm <damm@igel.co.jp>
> > > This patch adds a __free_irq() function for releasing 
> > > interrupts requested with setup_irq().
> > 
> > I think there is a simpler solution than adding yet another 
> > function for the confusion of driver writers. See below.
> 
> Uhm, i asked for that solution ;-) 

Uhm, I missed that :) 

> To reduce the confusion in generic code with yet another IRQF flag.

Hmm. I still prefer a solution which confuses the few people hacking
on kernel/irq/* instead of having another function which confuses the
already confused driver writers.

I can live with the two functions as well, but then please let us use
a function name which is more intuitive than __free_irq().

setup_irq()   -> remove_irq()
request_irq() -> free_irq()

Thanks,

	tglx

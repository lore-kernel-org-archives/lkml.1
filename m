Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZB1VOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZB1VOY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 16:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbZB1VOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 16:14:15 -0500
Received: from www.tglx.de ([62.245.132.106]:42273 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbZB1VOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 16:14:14 -0500
Date: Sat, 28 Feb 2009 22:13:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       a.p.zijlstra@chello.nl
Subject: Re: lockdep and threaded IRQs (was: ...)
In-Reply-To: <alpine.LFD.2.00.0902282149290.29264@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902282209450.29264@localhost.localdomain>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902280416.26687.david-b@pacbell.net> <alpine.LFD.2.00.0902281741560.29264@localhost.localdomain> <200902281202.36804.david-b@pacbell.net>
 <alpine.LFD.2.00.0902282149290.29264@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Feb 2009, Thomas Gleixner wrote:

> On Sat, 28 Feb 2009, David Brownell wrote:
> > Got a version that applies to mainline GIT?
> 
> http://tglx.de/~tglx/patches.tar.bz2 
>  
> > At a quick glance it looks like these patches don't cover
> > set_irq_chained_handler(), which would be trouble since
> > __setup_irq() doesn't get called in those cases.
> 
> Hmm, I did not think about chained handlers where the demux handler
> needs to run in a thread as well. Usually demux handlers just have a
> fast path kicking the particular real handlers.

I looked at the code in twl4030-irq.c and I don't think that the demux
handler needs to be setup as a chained handler at all.

Just register it as a standard handler and let it wakeup the other irq
threads or is there a particular requirement that the demuxed handlers
need to run in the same thread context as the demux handler itself ?

Thanks,

	tglx

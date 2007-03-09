Return-Path: <linux-kernel-owner+w=401wt.eu-S2992970AbXCIFKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992970AbXCIFKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 00:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992971AbXCIFKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 00:10:40 -0500
Received: from mx1.suse.de ([195.135.220.2]:46128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992970AbXCIFKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 00:10:39 -0500
Date: Fri, 9 Mar 2007 06:10:38 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [rfc][patch] futex: restartable futex_wait?
Message-ID: <20070309051038.GA12479@wotan.suse.de>
References: <20070307153349.GA32404@wotan.suse.de> <20070308172902.GA16834@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308172902.GA16834@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 06:29:02PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Hi Ingo,
> > 
> > I'm seeing an LTP test fail for ltp test sigaction_16_24. Basically, 
> > it tests whether the SA_RESTART flag works for the sem_wait operation.
> > 
> > I see sem_wait is implemented with futex_wait, so I wonder whether we 
> > can make it restartable? Am I going about it the right way? (Seems to 
> > fix the testcase here).
> 
> i think that's quite right. I'm wondering why this never came up before? 
> But your fix is not complete i think:
> 
> > +             restart->arg2 = time;
> > +             return -ERESTART_RESTARTBLOCK;
> > +     }
> 
> 'time' here is relative, so the restarted syscall will do a /full/ wait 
> again.

But it has been modified by schedule_timeout?


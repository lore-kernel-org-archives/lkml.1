Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZEIMrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZEIMrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 08:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZEIMrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 08:47:33 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54024 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZEIMrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 08:47:32 -0400
Date: Sat, 9 May 2009 21:41:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ron <ron@debian.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix for sched_clock() when using jiffies
Message-ID: <20090509124155.GA23191@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>, Ron <ron@debian.org>,
	mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
References: <20081126150645.GA28153@homer.shelbyville.oz> <1227712598.4454.199.camel@twins> <20081126153152.GB28153@homer.shelbyville.oz> <20081128144039.GG28138@elte.hu> <20090508132449.GV5417@homer.shelbyville.oz> <20090508200444.GA22132@homer.shelbyville.oz> <20090508160142.ad89944f.akpm@linux-foundation.org> <20090509004009.GZ5417@homer.shelbyville.oz> <20090508181559.4750800e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508181559.4750800e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 06:15:59PM -0700, Andrew Morton wrote:
> On Sat, 9 May 2009 10:10:09 +0930 Ron <ron@debian.org> wrote:
> > This was a resend of a patch that seemed to get a thumbs up, except
> > for whitespace damage in what I originally sent, but which apparently
> > then didn't get applied.  The original context to it was:
> > 
> >  I'm in the process of updating a port for an ARM based chip we've been
> >  working on, from 2.6.22-rc4'ish to the current HEAD of Linus' tree, and
> >  I started seeing the following:
> > 
> >  [    0.000000] PID hash table entries: 512 (order: 9, 2048 bytes)
> >  [42949372.970000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> > 
> >  The reason appears to be that printk_clock() has been replaced with a
> >  call to cpu_clock, which in our case currently falls back to the default
> >  (weak) implementation of sched_clock() that uses jiffies -- but doesn't
> >  account for the initial offset of the jiffy count.  The following simple
> >  patch fixes it for me, in line with what printk_clock used to do.
> 
> Removing printk_clock() always seemed a mildly wrong idea to me.
> 
> I'm sure we fixed this printk-timestamping ages and ages ago.  Maybe it
> came back, or maybe it's somehow specific to your setup?
> 
FWIW, I just ran in to this yesterday on a board with a single timer
channel (which is assigned over to clockevents so we can still do
tickless), using the jiffies clocksource. With printk_clock() gone, it
seems like anything using the jiffies clocksource ought to have this
problem.

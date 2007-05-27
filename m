Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbXE0UdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbXE0UdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 16:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbXE0UdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 16:33:15 -0400
Received: from waste.org ([66.93.16.53]:37804 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbXE0UdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 16:33:15 -0400
Date: Sun, 27 May 2007 15:32:21 -0500
From: Matt Mackall <mpm@selenic.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Folkert van Heusden <folkert@vanheusden.com>,
       Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [2.6.21.1] soft lockup when removing netconsole module
Message-ID: <20070527203221.GF11166@waste.org>
References: <20070526154011.GB3735@vanheusden.com> <465857DF.2020603@gmail.com> <1180195927.4264.11.camel@chaos> <20070526161645.GA11760@vanheusden.com> <1180197324.4264.23.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180197324.4264.23.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 06:35:24PM +0200, Thomas Gleixner wrote:
> On Sat, 2007-05-26 at 18:17 +0200, Folkert van Heusden wrote:
> > > > Seems to be hrtimers related - CC'ed Thomas.
> > > I doubt that. The tick interrupt just finds out, that the machine is
> > > stuck in rmmod.
> > > > > Also the rmmod hangs and would not exit even with kill -9. It also
> > > > > sucks up 100% cpu.
> > > Can you please enable CONFIG_PROVE_LOCKING ?
> >
> > Luckily I already had :-)
> > Here is its output:
> 
> So there is no output from lockdep, during the rmmod hang ? The rmmod
> sucks 100% cpu, so it busy loops at some place. Looking at the stack
> trace this seems to be in:
> 
> 
> void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,                                                                                                                 
>                                        struct delayed_work *dwork)                                                                                                                  
> {                                                                                                                                                                                   
>         while (!cancel_delayed_work(dwork))                                                                                                                                         
>                 flush_workqueue(wq);                                                                                                                                                
> }
> 
> which is not really related to timers :)

Looks like Steve added the delayed work bits, though I never saw any
of his patches.

-- 
Mathematics is the supreme nostalgia of our time.

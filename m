Return-Path: <linux-kernel-owner+w=401wt.eu-S1760409AbYCAMmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409AbYCAMmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 07:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYCAMmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 07:42:06 -0500
Received: from the.earth.li ([217.147.81.2]:47805 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYCAMmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 07:42:05 -0500
Date: Sat, 1 Mar 2008 12:42:04 +0000
From: Simon Huggins <huggie@earth.li>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080301124203.GL24533@paranoidfreak.co.uk>
References: <20080229115256.GG24533@paranoidfreak.co.uk> <20080229133433.GA15532@elte.hu> <20080229135137.GA23781@elte.hu> <20080229140024.GA26342@elte.hu> <20080229115256.GG24533@paranoidfreak.co.uk> <20080229133433.GA15532@elte.hu> <20080229193951.GI24533@paranoidfreak.co.uk> <20080229203914.GD27212@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229203914.GD27212@elte.hu>
X-Attribution: huggie
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(please cc me)

On Fri, Feb 29, 2008 at 09:39:14PM +0100, Ingo Molnar wrote:
> * Simon Huggins <huggie@earth.li> wrote:
> > On Fri, Feb 29, 2008 at 02:34:33PM +0100, Ingo Molnar wrote:
> > > * Simon Huggins <huggie@earth.li> wrote:
> > > > [ Please Cc me on replies ]
> > > > I had a bug with sdhci which Pierre Ossman looked at for me.
> > > > In the end essentially the fix was to use HZ=1000 and nothing else. 
> > > > Pierre seemed to think that this was a bug in the scheduler.
> > > does the patch below help, even if you keep HZ=100? This doesnt look 
> > > like a scheduler issue, it's more of a timer/timing issue. Different HZ 
> > > means different msleep() results - and the mmc code does a loop of small 
> > > msleep delays.
> > Thanks for looking at it.
> > I did tests with 2.6.24.3 with HZ=1000 and HZ=100 and as expected the
> > latter didn't work.
[..]
> > That doesn't work.  I did a test with HZ=100 and this patch.  I've 
> > attached the log as patch1-log.

> > Anything else I can try?
> so neither precise, nor imprecise timings help??

I don't know.  I don't really understand the patches I applied I'm
afraid; I'm just reporting the results.

I've cc'd Pierre Ossman so he might have a look from the sdhci point of
view.

Pierre, the thread starts here:
http://lkml.org/lkml/2008/2/29/118

Simon.

-- 
Just another wannabie |  "It's so nice to have a big   |  Just another fool
----------------------+ strong spud around the house." +-------------------
This message was brought to you by the letter E and the number 13.
htag.pl 0.0.22 -- http://www.earth.li/projectpurple/progs/htag.html

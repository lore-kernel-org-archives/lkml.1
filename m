Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbXC2Ty2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbXC2Ty2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 15:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934143AbXC2Ty2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 15:54:28 -0400
Received: from waste.org ([66.93.16.53]:34733 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934082AbXC2Ty1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 15:54:27 -0400
Date: Thu, 29 Mar 2007 14:40:49 -0500
From: Matt Mackall <mpm@selenic.com>
To: Mariusz =?utf-8?Q?Koz=C5=82owski?= <m.kozlowski@tuxland.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.21-rc5-mm1
Message-ID: <20070329194048.GG4892@waste.org>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <200703292045.13140.m.kozlowski@tuxland.pl> <20070329183857.GA13362@elte.hu> <200703292102.56503.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200703292102.56503.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 09:02:56PM +0200, Mariusz Kozłowski wrote:
> > > > > This is verified and repeatable _every_ single time I tried. 
> > > > > Unfortunately the last thing seen on the screen before system is 
> > > > > frozen is 'eth0: link down'. So my guess is that when hunting for 
> > > > > hangs I found something else that can hang my laptop (netconsole 
> > > > > that is).
> > > > 
> > > > fix-sysfs-reclaim-crash.patch is known-bad.  Did you try reverting 
> > > > that?
> > > 
> > > Yes, just tested it. Sorry. It doesn't change anything.
> > 
> > could you try a !CONFIG_SMP kernel to make sure it's not some 
> > self-locking of netconsole that is interfering? (Is it perhaps the 
> > 'eth0: link down' message that is trigger from within netconsole?)
> 
> This is from .config:
> 
> # CONFIG_SMP is not set
> 
> Can this be that 'link down' is emitted by netconsole when the link is
> already down and kernel gets locked? Does it make any sense?

Yes, that's probably exactly the problem. But it probably involves locks.

I think a preemptible kernel can also cause the problem?

-- 
Mathematics is the supreme nostalgia of our time.

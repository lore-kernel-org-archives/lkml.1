Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbXLFQK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbXLFQK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXLFQKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:10:51 -0500
Received: from waste.org ([66.93.16.53]:60107 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbXLFQKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:10:50 -0500
Date: Thu, 6 Dec 2007 10:09:50 -0600
From: Matt Mackall <mpm@selenic.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071206160950.GX19691@waste.org>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <20071204164720.6e4dc2c4@the-village.bc.nu> <475599D6.4030008@cosmosbay.com> <20071205212646.GP17536@waste.org> <47579E89.6080802@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47579E89.6080802@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 08:02:33AM +0100, Eric Dumazet wrote:
> Matt Mackall a ?crit :
> >On Tue, Dec 04, 2007 at 07:17:58PM +0100, Eric Dumazet wrote:
> >>Alan Cox a ?crit :
> >>>>No matter what you consider as being better, changing a 12 years old 
> >>>>and widely used userspace interface like /dev/urandom is simply not an 
> >>>>option.
> >>>>   
> >>>Fixing it to be more efficient in its use of entropy and also fixing the
> >>>fact its not actually a good random number source would be worth looking
> >>>at however.
> >>> 
> >>Yes, since current behavior on network irq is very pessimistic.
> >
> >No, it's very optimistic. The network should not be trusted.
> 
> You keep saying that. I am refering to your previous attempts last year to 
> remove net drivers from sources of entropy. No real changes were done.

Dave and I are both a bit stubborn on this point. I've been meaning to
respin those patches..

> If the network should not be trusted, then a patch should make sure network 
> interrupts feed /dev/urandom but not /dev/random at all. (ie not calling 
> credit_entropy_store() at all)

Yes. My plan is to change the interface from SA_SAMPLE_RANDOM to
add_network_entropy. The SA_SAMPLE_RANDOM interface sucks because it
doesn't tell the core what kind of source it's dealing with.

> There is a big difference on get_cycles() and jiffies. You should try to 
> measure it on a typical x86_64 platform.

I'm well aware of that. We'd use get_cycles() exclusively, but it
returns zero on lots of platforms. We used to use sched_clock(), I
can't remember why that got changed.

> >Also, for future reference, patches for /dev/random go through me, not
> >through Dave.
> 
> Why ? David is the network maintainer, and he was the one who rejected your 
> previous patches.

Because I'm the /dev/random maintainer and it's considered the polite
thing to do, damnit.

-- 
Mathematics is the supreme nostalgia of our time.

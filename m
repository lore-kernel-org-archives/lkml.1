Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbYIDRbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbYIDRbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYIDRbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:31:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:60617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbYIDRbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:31:08 -0400
Date: Thu, 4 Sep 2008 10:30:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-pci@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] Return value from schedule()
Message-ID: <20080904103049.01f748d9@infradead.org>
In-Reply-To: <20080904162111.GM2772@parisc-linux.org>
References: <20080827204626.4b65862f@extreme>
	<20080828111323.GI7908@solarflare.com>
	<20080903155713.7fab2e19@extreme>
	<20080904160739.GK2772@parisc-linux.org>
	<20080904161424.GA23042@elte.hu>
	<20080904162111.GM2772@parisc-linux.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 10:21:11 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, Sep 04, 2008 at 06:14:24PM +0200, Ingo Molnar wrote:
> > > If schedule() returned whether or not it had scheduled another
> > > task, we could do something like:
> > > 
> > > 		if (!schedule())
> > > 			udelay(10);
> > 
> > hm, i'm not really sure - this really just seems to be a higher
> > prio variant of yield() combined with some weird code. Do we really
> > want to promote such arguably broken behavior? If there's any
> > chance of any polling to take a material amount of CPU time it
> > should be event driven to begin with.
> 
> Oh, I'm not concerned about CPU utilisation, I'm concerned about PCI
> bus utilisation.  Perhaps I'd like a yield_timeout() function instead
> where I say that I'd like to not run for at least 10 microseconds?
> 
> Can we do that, or are we still jiffie-based there?
> 

use schedule_hrtimerout() for this (hopefully will be in 2.6.28);
see this weeks LWN for an article describing it

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbXGDIzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbXGDIzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760317AbXGDIyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:54:44 -0400
Received: from tim.rpsys.net ([194.106.48.114]:43613 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760063AbXGDIyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:54:41 -0400
Subject: Re: [PATCH/RFC] oops and panic message logging to MTD
From: Richard Purdie <rpurdie@openedhand.com>
To: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Cc: dedekind@infradead.org, linux-mtd <linux-mtd@lists.infradead.org>
In-Reply-To: <20070703094702.GA11992@angel.research.nokia.com>
References: <1182184301.6074.62.camel@localhost.localdomain>
	 <1182239749.4403.48.camel@sauron>
	 <1182247254.5760.17.camel@localhost.localdomain>
	 <20070703094702.GA11992@angel.research.nokia.com>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 09:54:21 +0100
Message-Id: <1183539261.4538.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 12:47 +0300, Jarkko Lavinen wrote:
> On Tue, Jun 19, 2007 at 11:00:54AM +0100, Richard Purdie wrote:
> > Its not a case of formatting the whole partition. The whole point of
> > this code is the following use case:
> > 
> > 1. Device crashes
> > 2. Device reboots
> > 3. mtdoops partition has a log of why it crashed
> 
> The oops logger uses oops_in_progress variable to detect the begin and the 
> end of an oops.  The end is detected when the first non-oops line comes and
> oops_in_progress is false.
> 
> This works if the kernel is still running after the oops and gemerates some 
> non-oops messages.  But if there is no non-oops line following an oops, no
> flushing will occur and there won't be a log on flash.

There was a printk within bust_spinlocks which flushed the klogd queues
and hence flushed the mtd_oops queue too.

I've noticed this has recently been removed and replaced with a wait
queue [1] and hence the problem mentioned above now exists (but didn't
when the driver was developed).

[1] http://git.o-hand.com/?p=linux-rpurdie;a=commitdiff;h=e3e8a75d2acfc61ebf25524666a0a2c6abb0620c

This raises the question of how to known when the oops has completed.
The neatest solution I can see would be to add some kind of optional
sync function pointer to struct console. Would that be acceptable?

Richard


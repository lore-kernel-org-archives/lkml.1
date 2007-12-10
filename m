Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbXLJVAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbXLJVAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXLJVAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:00:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbXLJVAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:00:13 -0500
Date: Mon, 10 Dec 2007 12:59:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-Id: <20071210125923.37bd2f10.akpm@linux-foundation.org>
In-Reply-To: <20071210204212.GA5502@elte.hu>
References: <200712080340.49546.rjw@sisk.pl>
	<20071210204212.GA5502@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2007 21:42:12 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Subject		: jiffies counter leaps in 2.6.24-rc3
> > Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
> > References	: http://lkml.org/lkml/2007/11/24/53
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
> > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > Patch		: http://lkml.org/lkml/2007/12/7/132
> 
> Linus, Andrew, i need some help deciding what to do about this 
> regression. The fixes for this have been tested and resolve the 
> regression, but they change printk and other code that runs by default 
> and is thus rather invasive so late in the v2.6.24 cycle. This bug 
> should only affect CONFIG_PRINTK_TIME=y kernels (a non-default debug 
> option) - although some claimed effect was on udelay()/mdelay() too.
> 
> i've attached below the queue of 5 patches that fix this problem. They 
> have been build and boot tested with more than 1000 random kernels in 
> the past few days, so i certainly trust the core and x86 bits of this.
> 
> what do you think? Right now i've got them queued up for 2.6.25 in both 
> the scheduler-devel and the x86-devel git trees - but can submit them 
> for 2.6.24 if it's better if we did them there. I've got no strong 
> opinion either way.

printk_clock() doesn't seem terribly important but what's this stuff about
effects on udelay/mdelay?  That can be serious if they're getting
shortened.


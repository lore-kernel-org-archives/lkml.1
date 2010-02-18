Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab0BRXdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:33:14 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45603 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab0BRXdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:33:12 -0500
Subject: Re: printk_ratelimited() not compiling
From: john stultz <johnstul@us.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1266535419.8446.320.camel@Joe-Laptop.home>
References: <1266531013.3201.86.camel@localhost.localdomain>
	 <1266532567.3201.97.camel@localhost.localdomain>
	 <1266535419.8446.320.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 15:33:07 -0800
Message-ID: <1266535987.3201.100.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 15:23 -0800, Joe Perches wrote:
> On Thu, 2010-02-18 at 14:36 -0800, john stultz wrote: 
> > > Am I missing something obvious, or did something get broken after this went in?
> > Ok. Solved it. I needed to #include <linux/ratelimit.h> in the file I
> > was adding the printk_ratelimited usage in, rather then where
> > printk_ratelimited is defined.
> > 
> > Maybe would it be better to move the printk_ratelimited definitions into
> > ratelimit.h so this would be more obvious?
> 
> That's one option.
> 
> Probably the only places I tried it had an
> #include <linux/net.h> somewhere which does an
> #include <linux/ratelimit.h>
> 
> Personally, I think it'd be better to put
> #include <linux/ratelimit.h> back in kernel.h
> Commit 3fff4c42bd0a89869a0eb1e7874cc06ffa4aa0f5 removed it.

Right, that's what I tried first, but it doesn't build. :)

If ratelimit.h has to be included for it to work (which is fine by me),
it seems ratelimit.h would be the ideal place to define it.

CC'ing Peter to see what his thoughts are.

thanks
-john




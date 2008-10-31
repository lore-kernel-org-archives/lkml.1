Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbYJaHw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYJaHw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 03:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYJaHwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 03:52:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38791
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbYJaHwo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 03:52:44 -0400
Date: Fri, 31 Oct 2008 00:52:19 -0700 (PDT)
Message-Id: <20081031.005219.141937694.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: shemminger@vyatta.com, zbr@ioremap.net, rjw@sisk.pl, mingo@elte.hu,
       s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, efault@gmx.de,
       akpm@linux-foundation.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0810302047030.22084@wrl-59.cs.helsinki.fi>
References: <20081026122300.GA30905@ioremap.net>
	<20081030111526.7d9bb0f8@extreme>
	<Pine.LNX.4.64.0810302047030.22084@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 30 Oct 2008 21:01:19 +0200 (EET)

> On Thu, 30 Oct 2008, Stephen Hemminger wrote:
> 
> > Has anyone looked into the impact of port randomization on this benchmark.
> > If it is generating lots of sockets quickly there could be an impact:
> >   * port randomization causes available port space to get filled non-uniformly
> >     and what was once a linear scan may have to walk over existing ports.
> >     (This could be improved by a hint bitmap)
> > 
> >   * port randomization adds at least one modulus operation per socket
> >     creation. This could be optimized by using a loop instead.
> 
> I did something with AIM9's tcp_test recently (1-2 days ago depending on 
> how one calculates that so didn't yet have time summarize the details in 
> the AIM9 thread) by deterministicly binding in userspace and got much more 
> sensible numbers than with randomized ports (2-4%/5-7% vs 25% variation 
> some difference in variation in different kernel versions even with 
> deterministic binding). Also, I'm still to actually oprofile and bisect 
> the remaining ~4% regression (around 20% was reported by Christoph). For 
> oprofiling I might have to change aim9 to do predefined number of loops 
> instead of a deadline to get more consistent view on changes in per func 
> runtime.

Yes, it looks like port selection cache and locking effects are
a very real issue.

Good find.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbYJ3TFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbYJ3TFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYJ3TFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:05:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43490 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbYJ3TFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:05:04 -0400
Date: Thu, 30 Oct 2008 21:01:19 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Evgeniy Polyakov <zbr@ioremap.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Evgeniy Polyakov <s0mbre@tservice.net.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
In-Reply-To: <20081030111526.7d9bb0f8@extreme>
Message-ID: <Pine.LNX.4.64.0810302047030.22084@wrl-59.cs.helsinki.fi>
References: <20081009231759.GA8664@tservice.net.ru> <20081010115518.GA3159@tservice.net.ru>
 <20081010115725.GD19487@elte.hu> <200810250025.35734.rjw@sisk.pl>
 <20081026112924.GA29258@ioremap.net> <20081026122300.GA30905@ioremap.net>
 <20081030111526.7d9bb0f8@extreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008, Stephen Hemminger wrote:

> Has anyone looked into the impact of port randomization on this benchmark.
> If it is generating lots of sockets quickly there could be an impact:
>   * port randomization causes available port space to get filled non-uniformly
>     and what was once a linear scan may have to walk over existing ports.
>     (This could be improved by a hint bitmap)
> 
>   * port randomization adds at least one modulus operation per socket
>     creation. This could be optimized by using a loop instead.

I did something with AIM9's tcp_test recently (1-2 days ago depending on 
how one calculates that so didn't yet have time summarize the details in 
the AIM9 thread) by deterministicly binding in userspace and got much more 
sensible numbers than with randomized ports (2-4%/5-7% vs 25% variation 
some difference in variation in different kernel versions even with 
deterministic binding). Also, I'm still to actually oprofile and bisect 
the remaining ~4% regression (around 20% was reported by Christoph). For 
oprofiling I might have to change aim9 to do predefined number of loops 
instead of a deadline to get more consistent view on changes in per func 
runtime.

AIM9 is one process only so scheduler has a bit less to do in that 
benchmark anyway.

It would probably be nice to test just the port randomizer separately to 
see if there's some regression in that but I don't expect it to happen
any time soon unless I quickly come up with something in the bisection.


-- 
 i.

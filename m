Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbYJ3Skm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbYJ3Skm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbYJ3Skb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:40:31 -0400
Received: from matrixpower.ru ([195.178.208.66]:56683 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbYJ3Ska (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:40:30 -0400
Date: Thu, 30 Oct 2008 21:40:24 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Evgeniy Polyakov <s0mbre@tservice.net.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081030184024.GA6314@ioremap.net>
References: <20081009231759.GA8664@tservice.net.ru> <20081010115518.GA3159@tservice.net.ru> <20081010115725.GD19487@elte.hu> <200810250025.35734.rjw@sisk.pl> <20081026112924.GA29258@ioremap.net> <20081026122300.GA30905@ioremap.net> <20081030111526.7d9bb0f8@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030111526.7d9bb0f8@extreme>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 11:15:26AM -0700, Stephen Hemminger (shemminger@vyatta.com) wrote:
> Has anyone looked into the impact of port randomization on this benchmark.
> If it is generating lots of sockets quickly there could be an impact:
>   * port randomization causes available port space to get filled non-uniformly
>     and what was once a linear scan may have to walk over existing ports.
>     (This could be improved by a hint bitmap)
> 
>   * port randomization adds at least one modulus operation per socket
>     creation. This could be optimized by using a loop instead.

In this benchmark only two sockets are created per client for the whole
run, so this should not have any impact on performance.

-- 
	Evgeniy Polyakov

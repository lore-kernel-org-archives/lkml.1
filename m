Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYJaVTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYJaVTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYJaVTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:19:03 -0400
Received: from broadrack.ru ([195.178.208.66]:35666 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbYJaVTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:19:01 -0400
Date: Sat, 1 Nov 2008 00:18:58 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, ilpo.jarvinen@helsinki.fi,
       rjw@sisk.pl, mingo@elte.hu, s0mbre@tservice.net.ru,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081031211858.GA11137@ioremap.net>
References: <Pine.LNX.4.64.0810302047030.22084@wrl-59.cs.helsinki.fi> <20081031.005219.141937694.davem@davemloft.net> <Pine.LNX.4.64.0810311119510.7072@wrl-59.cs.helsinki.fi> <20081031.025159.51432990.davem@davemloft.net> <490AE1CD.9040207@cosmosbay.com> <20081031125713.6c6923de@extreme> <20081031201016.GA4748@ioremap.net> <490B7284.2010003@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490B7284.2010003@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric.

On Fri, Oct 31, 2008 at 10:03:00PM +0100, Eric Dumazet (dada1@cosmosbay.com) wrote:
> Just to be clear, this change was not meant to be committed.
> It already was rejected by David some years ago (2005, and 2006)
> 
> http://www.mail-archive.com/netdev@vger.kernel.org/msg07382.html
> 
> If you read my mail, I was *only* saying that tbench results can be 
> sensible to
> cache line ping pongs. tbench is a crazy benchmark, and only is a crazy 
> benchmark.

No problem Eric, I just pointed that this particular case is rather
fluffy, which really does not fix anything. It improves the case, but
the way it does it, is not the right one imho.
We would definitely want to eliminate assignment of global constantly
updated variables in the pathes where it is not required, but in a
way which does improve the design and implementation, but not to
hide some other problem.

Tbench is, well, as is it is quite usual network server :)
Dbench side is rather non-optimized, but still it is quite common
pattern of small-sized IO. Anyway, optimizing for some kind of the
workload tends to force other side to become slower, so I agree of
course that any narrow-viewed optimizations are bad, and instead we
should focus on searching error patter more widerspread.

-- 
	Evgeniy Polyakov

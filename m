Return-Path: <linux-kernel-owner+w=401wt.eu-S933754AbXFEXhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbXFEXhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760231AbXFEXg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:36:58 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:51913 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553AbXFEXg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:36:57 -0400
Date: Tue, 5 Jun 2007 16:36:16 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, yoshfuji@linux-ipv6.org, berni@birkenwald.de,
       stable@kernel.org, linkfanel@yahoo.fr
Subject: Re: [stable] "[IPV6]: Fix routing round-robin locking." breaks
	manual default route (bug 8349)
Message-ID: <20070605233616.GF3723@sequoia.sous-sol.org>
References: <465B45E0.3040007@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465B45E0.3040007@simon.arlott.org.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Simon Arlott (simon@fire.lp0.eu) wrote:
> Adding a ::/0 route doesn't work:
> # ip -6 r a ::/0 via fe80::230:18ff:feb0:25c2 dev eth0
> # ping6 -c 1 2001:4b10:1005:0:205:b4ff:fe12:530
> connect: Network is unreachable
> 
> A route assigned by addrconf works.
> 
> Reverting this patch from 2.6.22-rc3 fixes it:
> 	commit f11e6659ce9058928d73ff440f9b40a818d628ab
> 	Author: David S. Miller <davem@sunset.davemloft.net>
> 	Date:   Sat Mar 24 20:36:25 2007 -0700
> 	    [IPV6]: Fix routing round-robin locking.
> 
> This patch is was added to 2.6.20.5, breaking -stable too.

Rather than reverting that patch, applying this patch should fix
your ipv6 issue:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=7ebba6d14f8d63cad583bf1cc0330b601d5a8171

I'll wait for Dave or Yoshifuji to decide if this is a proper -stable
patch.

thanks,
-chris

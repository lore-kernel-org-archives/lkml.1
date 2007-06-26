Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbXFZNWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbXFZNWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 09:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXFZNW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 09:22:27 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:24787 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752236AbXFZNW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 09:22:27 -0400
Message-ID: <46811292.1010501@sw.ru>
Date: Tue, 26 Jun 2007 17:20:18 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>,
       netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [NETFILTER] early_drop() imrovement (v3)
References: <4615FE1D.80206@sw.ru> <20070406102433.d3a670a5.dada1@cosmosbay.com> <4616203A.80203@sw.ru> <4616626C.9020100@trash.net> <4617845F.7080203@sw.ru> <461789CF.8000106@cosmosbay.com> <46187770.1070106@sw.ru> <46417137.5080501@sw.ru> <467FC8D2.5070102@trash.net>
In-Reply-To: <467FC8D2.5070102@trash.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:

Patrick, thank you for your tips, I'll remake the patch.

> I don't like the NF_CT_PER_BUCKET constant. First of all, each
> conntrack is hashed twice, so its really only 1/2 of the average
> conntracks per bucket. Secondly, its only a default and many
> people use nf_conntrack_max = nf_conntrack_htable_size / 2, so
> using this constant for early_drop seems wrong.

> Perhaps make it 2 * nf_conntrack_max / nf_conntrack_htable_size
> or even add a nf_conntrack_eviction_range sysctl.

IMHO The number of conntracks checked in early_drop() have following restrictions:
- it should be not too low -- to decrease chances of transmission failures,
- it should be limited by some reasonable value -- to prevent long check delays.

Also I believe it makes sense to have it constant (how about NF_CT_EVICTION
name?) -- to have the same behaviour on various nodes. However I doubt strongly
that anybody will want to change this value. Do you think it is really required?

thank you,
	Vasily Averin

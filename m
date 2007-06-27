Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbXF0Iwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbXF0Iwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 04:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbXF0Iwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 04:52:40 -0400
Received: from stinky.trash.net ([213.144.137.162]:51548 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbXF0Iwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 04:52:39 -0400
Message-ID: <46822540.2010004@trash.net>
Date: Wed, 27 Jun 2007 10:52:16 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Vasily Averin <vvs@sw.ru>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>,
       netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
References: <4615FE1D.80206@sw.ru> <20070406102433.d3a670a5.dada1@cosmosbay.com> <4616203A.80203@sw.ru> <4616626C.9020100@trash.net> <4617845F.7080203@sw.ru> <461789CF.8000106@cosmosbay.com> <46187770.1070106@sw.ru> <46417137.5080501@sw.ru> <467FC8D2.5070102@trash.net> <46811292.1010501@sw.ru> <468223D0.90305@sw.ru>
In-Reply-To: <468223D0.90305@sw.ru>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Averin wrote:
> When the number of conntracks is reached nf_conntrack_max limit, early_drop()
> tries to free one of already used conntracks. If it does not find any conntracks
> that may be freed, it leads to transmission errors.
> In current implementation the conntracks are searched in one hash bucket only.
> It have some drawbacks: if used hash bucket is empty we have not any chances to
> find something. On the other hand the hash bucket can contain a huge number of
> conntracks and its check can last a long time.
> The proposed patch limits the number of checked conntracks and allows to search
> conntracks in other hash buckets. As result in any case the search will have the
> same chances to free one of the conntracks and the check will not lead to long
> delays.


Thanks Vasily. I have some patches queued to convert all conntrack
hashes to hlists, which conflict with your patches. They need a bit
more work, I'll integrate your changes on top of them once I'm done.

BTW, I played around with your last patch yesterday and it shows
a big improvement when flooding the machine with new connections.
Previously about 5% of the (valid) new connections would get
dropped, with your patch not a single one :)


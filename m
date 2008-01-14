Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYANGOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYANGOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYANGOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:14:37 -0500
Received: from stinky.trash.net ([213.144.137.162]:62107 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYANGOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:14:36 -0500
Message-ID: <478AFC92.50508@trash.net>
Date: Mon, 14 Jan 2008 07:09:22 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Al Viro <viro@ZenIV.linux.org.uk>, m.kozlowski@tuxland.pl,
       davem@davemloft.net, sparclinux@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sparc oops in ip_fast_csum
References: <20080105094400.GH27894@ZenIV.linux.org.uk> <E1JBJHA-0000hy-00@gondolin.me.apana.org.au> <20080106020214.GQ27894@ZenIV.linux.org.uk> <20080106041430.GA3784@gondor.apana.org.au>
In-Reply-To: <20080106041430.GA3784@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Patrick, please have a look at the former.  In fact it's not just
> that ihl may be bogus (which might be harmless as long as the REJECT
> hook only gets called from within the IP stack), I think REJECT would
> also do the wrong thing if the packet had IP options.  So perhaps we
> should just make it create a packet from scratch rather than being
> too clever in reusing the old one.


We currently silently drop packets with IP options in the reject
target. The length check should be fine since its only called
through the IP stack or bridge netfilter, which replicates the
IP stack checks.

But I agree to your suggestion, that will allow us to properly
handle packets with IP options. I'll take care of this.

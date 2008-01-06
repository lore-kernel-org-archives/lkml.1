Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYAFCC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYAFCC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 21:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYAFCCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 21:02:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42484 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYAFCCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 21:02:20 -0500
Date: Sun, 6 Jan 2008 02:02:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: m.kozlowski@tuxland.pl, davem@davemloft.net, sparclinux@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc oops in ip_fast_csum
Message-ID: <20080106020214.GQ27894@ZenIV.linux.org.uk>
References: <20080105094400.GH27894@ZenIV.linux.org.uk> <E1JBJHA-0000hy-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JBJHA-0000hy-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 11:22:04AM +1100, Herbert Xu wrote:
> Actually if you read the code for ip_fast_csum it's obvious what has
> happened.  %o1 == iph->ihl contains the value 2 which is bogus.
> 
> [IPV4] raw: Strengthen check on validity of iph->ihl 
> 
> We currently check that iph->ihl is bounded by the real length and that
> the real length is greater than the minimum IP header length.  However,
> we did not check the caes where iph->ihl is less than the minimum IP
> header length.
> 
> This breaks because some ip_fast_csum implementations assume that which
> is quite reasonable.

Humm...  Point, but that makes me wonder what other callers do...

E.g. what about ipt_REJECT.c::send_reset()?  Or myri10ge_get_frag_header()?

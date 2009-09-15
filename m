Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZIOABj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZIOABj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 20:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbZIOABh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 20:01:37 -0400
Received: from ja.ssi.bg ([217.79.71.194]:60078 "EHLO u.domain.uli"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755394AbZIOABg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 20:01:36 -0400
Date: Tue, 15 Sep 2009 03:01:47 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@u.domain.uli
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Stephan von Krawczynski <skraw@ithnet.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: ipv4 regression in 2.6.31 ?
In-Reply-To: <20090914093128.4d709ff6@nehalam>
Message-ID: <Pine.LNX.4.58.0909150159580.3947@u.domain.uli>
References: <20090914150935.cc895a3c.skraw@ithnet.com> <4AAE4BAF.2010406@gmail.com>
 <20090914175505.a3f132ee.skraw@ithnet.com> <20090914093128.4d709ff6@nehalam>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Mon, 14 Sep 2009, Stephen Hemminger wrote:

> RP filter did not work correctly in 2.6.30. The code added to to the loose
> mode caused a bug; the rp_filter value was being computed as:
>   rp_filter = interface_value & all_value;
> So in order to get reverse path filter both would have to be set.

	May be we can add IN_DEV_MASKCONF as a better
option (all & dev). All loose-mode fans just need to set
all/rp_filter to 3 to allow both strict and loose mode and then 
DEV/rp_filter will be restricted to the allowed modes. By this way 
compatibility is preserved (all/rp_filter will mean "allowed modes")
and you can add other loose-mode variants as explained in RFC 3704.
Then strict mode will have priority to all loose modes when checking
the sender address. Or if we really want to help asymmetric routing
we should not play with loose modes but with solutions like 
rp_filter_mask:

http://www.ssi.bg/~ja/#rp_filter_mask

where we can use the DEV/medium_id knowledge for rp_filter, not
just for proxy_arp. The drawback is that currently it is
limited to 31 mediums. Still, it serves the main goal of
RFC 3704: 2.3. Feasible Path Reverse Path Forwarding.
Then users can use loose mode to fight against martians
or rp_filter_mask for setups with asymmetric routing.

Regards

--
Julian Anastasov <ja@ssi.bg>

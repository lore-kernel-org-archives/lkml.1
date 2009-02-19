Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZBSBLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZBSBLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZBSBLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:11:11 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:11817 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZBSBLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:11:10 -0500
Message-ID: <499CB1AA.70801@hp.com>
Date: Wed, 18 Feb 2009 20:11:06 -0500
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: chuck.lever@oracle.com, tytso@mit.edu, Valdis.Kletnieks@vt.edu,
       arvidjaar@mail.ru, rjw@sisk.pl, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, jamagallon@ono.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 regression? Bonding tied to IPV6 in 29-rc5
References: <20090218135537.GF3600@mini-me.lan>	<06F54D7E-EE07-49C9-AD8F-B46BD6B02ABA@oracle.com>	<499C5486.5020807@hp.com> <20090218.141431.103832064.davem@davemloft.net>
In-Reply-To: <20090218.141431.103832064.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Vlad Yasevich <vladislav.yasevich@hp.com>
> Date: Wed, 18 Feb 2009 13:33:42 -0500
> 
>> Would a module parameter that disables ipv6 or at least addrconf be
>> enough of a solution?
> 
> We have it, it's just that (as others have stated) it doesn't
> prevent IPV6 sockets from being openned by applications.
> 

Is that what people really want to block?

Or do they want to prevent the use of IPv6 in environments where
IPv6 is not supported?  If it's this case, then simply not configuring
any IPv6 addresses on the system interfaces will make it seem as if
IPv6 is not there.

Without IPv6 addresses, AF_INET6 sockets are the same as AF_INET.
I really see no reason to block them.  Any legacy apps that people
might worry about don't use this type socket any way.

One doesn't even need to worry about processing IPv6 traffic,
since the system would never join any IPv6 multicast groups and thus
would never see 99% of the traffic.

-vlad

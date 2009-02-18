Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZBRF4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZBRF4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 00:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZBRF4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 00:56:03 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:26995 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZBRF4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 00:56:00 -0500
X-IronPort-AV: E=Sophos;i="4.38,227,1233532800"; 
   d="scan'208";a="132876536"
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: Valdis.Kletnieks@vt.edu, arvidjaar@mail.ru, rjw@sisk.pl,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       jamagallon@ono.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 regression? Bonding tied to IPV6 in 29-rc5
References: <200902172001.41804.arvidjaar@mail.ru>
	<20090217.142946.232071526.davem@davemloft.net>
	<25143.1234932076@turing-police.cc.vt.edu>
	<20090217.212919.259912220.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 17 Feb 2009 21:55:58 -0800
In-Reply-To: <20090217.212919.259912220.davem@davemloft.net> (David Miller's
	message of "Tue, 17 Feb 2009 21:29:19 -0800 (PST)")
Message-ID: <adar61w2sr5.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Feb 2009 05:55:59.0198 (UTC) FILETIME=[928E37E0:01C9918D]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Next, if it's just an issue of IPV6 traffic, install a packet
 > scheduler rule that rejects all packets with ethernet proto
 > ETH_P_IPV6
 > 
 > If openning up ipv6 sockets is problematic, that can be blocked
 > using the security layer, which your super-duper distro kernel
 > is guarenteed to have enabled. :-)

This reminds me of a related issue that some users have run into with
IP-over-InfiniBand -- the IPoIB module also depends on ipv6 symbols if
ipv6 is enabled, so when ipoib is loaded then ipv6 gets loaded.  And
this causes a problem from some people in the IB case because assigning
an ipv6 address to the ipoib interface actually consumes some network
resources (the number of multicast groups that the network supports may
be limited and having a solicited node multicast group for each node may
use them all up).

Anyway, this leads to the folowing question: is there a way to prevent a
link-local ipv6 address from being configured automatically for the
ipoib interface?

Thanks,
  Roland

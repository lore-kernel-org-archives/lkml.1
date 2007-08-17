Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbXHQTxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbXHQTxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXHQTxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:53:34 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:2838 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbXHQTxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:53:32 -0400
X-IronPort-AV: i="4.19,277,1183359600"; 
   d="scan'208"; a="202059506:sNHT1700834931"
To: David Miller <davem@davemloft.net>
Cc: tom@opengridcomputing.com, jeff@garzik.org, swise@opengridcomputing.com,
       mshefty@ichips.intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports from the host TCP port space.
X-Message-Flag: Warning: May contain useful information
References: <46C310E1.7020503@opengridcomputing.com>
	<46C3B5EF.5060409@garzik.org>
	<1187271791.4685.9.camel@trinity.ogc.int>
	<20070816.141751.115907875.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 17 Aug 2007 12:52:39 -0700
In-Reply-To: <20070816.141751.115907875.davem@davemloft.net> (David Miller's message of "Thu, 16 Aug 2007 14:17:51 -0700 (PDT)")
Message-ID: <adaodh6x7js.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Aug 2007 19:52:39.0470 (UTC) FILETIME=[2AA394E0:01C7E108]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Isn't RDMA _part_ of the "software net stack" within Linux?

 > It very much is not so.

This is just nit-picking.  You can draw the boundary of the "software
net stack" wherever you want, but I think Sean's point was just that
RDMA drivers already are part of Linux, and we all want them to get
better.

 > When using RDMA you lose the capability to do packet shaping,
 > classification, and all the other wonderful networking facilities
 > you've grown to love and use over the years.

Same thing with TSO and LRO and who knows what else.  I know you're
going to make a distinction between "stateless" and "stateful"
offloads, but really it's just an arbitrary distinction between things
you like and things you don't.

 > Imagine if you didn't know any of this, you purchase and begin to
 > deploy a huge piece of RDMA infrastructure, you then get the mandate
 > from IT that you need to add firewalling on the RDMA connections at
 > the host level, and "oh shit" you can't?

It's ironic that you bring up firewalling.  I've had vendors of iWARP
hardware tell me they would *love* to work with the community to make
firewalling work better for RDMA connections.  But instead we get the
catch-22 of your changing arguments -- first, you won't even consider
changes that might help RDMA work better in the name of
maintainability; then you have to protect poor, ignorant users from
accidentally using RDMA because of some problem or another; and then
when someone tries to fix some of the problems you mention, it's back
to step one.

Obviously some decisions have been prejudged here, so I guess this
moves to the realm of politics.  I have plenty of interesting
technical stuff, so I'll leave it to the people with a horse in the
race to find ways to twist your arm.

 - R.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762152AbXIMVLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152AbXIMVLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbXIMVLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:11:32 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:16088 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbXIMVLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:11:31 -0400
X-IronPort-AV: E=Sophos;i="4.20,251,1186383600"; 
   d="scan'208";a="398956236"
To: Steve Wise <swise@opengridcomputing.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
References: <adahclymos8.fsf@cisco.com>
	<46E97BB0.9030106@opengridcomputing.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 13 Sep 2007 14:11:29 -0700
In-Reply-To: <46E97BB0.9030106@opengridcomputing.com> (Steve Wise's message of "Thu, 13 Sep 2007 13:04:32 -0500")
Message-ID: <adaps0ml18e.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Sep 2007 21:11:30.0221 (UTC) FILETIME=[A78A25D0:01C7F64A]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I was about to post v2 of my patch to avoid port space collisions with
 > the native stack.  Can we get that 2.6.24?  It is high priority
 > IMO. I've tried to solicit review on it, but I think folks are
 > reluctant... ;-)

I would like to get this in, but I'm still at least a little
reluctant, since we would be committing to a user interface that seems
a little awkward at best, so I'd like to try and find something
better.  Just to summarize my understanding:

 - your patch requires the administration to configure an ethX:iwY
   alias address to use iwarp.  (By the way is there anything other
   than "don't do that" that avoids assigning the same address to the
   iwarp alias and a non-iwarp interface?)

 - it would be nicer to create the alias automatically, but an alias
   without an address doesn't make sense.  Creating a whole separate
   net device causes problems because the iwarp stuff still needs to
   use the main net device to do ARP etc.

 - so I'm out of better ideas but I still want to push back a little
   before we commit to something ugly.

I've been meaning to track down the bnx2 iscsi offload patch to look
and see if this issue is addressed, since the same problem seems to
exist: it seems an iscsi connection and a main stack tcp connection
might share the same 4-tuple unless something is done to avoid that
happening.

Also, I think it behooves us to get some agreement on this approach
with NetEffect and Kanoj (NetXen?) at least, since their iwarp drivers
seem to be imminent.

 - R.

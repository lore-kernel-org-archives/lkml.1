Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbXHUHAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbXHUHAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761894AbXHUG6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:58:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47570
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761667AbXHUG6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:58:06 -0400
Date: Mon, 20 Aug 2007 23:58:04 -0700 (PDT)
Message-Id: <20070820.235804.85409183.davem@davemloft.net>
To: rdreier@cisco.com
Cc: tom@opengridcomputing.com, jeff@garzik.org, swise@opengridcomputing.com,
       mshefty@ichips.intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <adalkc5u1o9.fsf@cisco.com>
References: <adatzqxwh56.fsf@cisco.com>
	<20070817.234405.66176298.davem@davemloft.net>
	<adalkc5u1o9.fsf@cisco.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 20 Aug 2007 18:16:54 -0700

> And direct data placement really does give you a factor of two at
> least, because otherwise you're stuck receiving the data in one
> buffer, looking at some of the data at least, and then figuring out
> where to copy it.  And memory bandwidth is if anything becoming more
> valuable; maybe LRO + header splitting + page remapping tricks can get
> you somewhere but as NCPUS grows then it seems the TLB shootdown cost
> of page flipping is only going to get worse.

As Herbert has said already, people can code for this just like
they have to code for RDMA.

There is no fundamental difference from converting an application
to sendfile or similar.

The only thing this needs is a
"recvmsg_I_dont_care_where_the_data_is()" call.  There are no alignment
issues unless you are trying to push this data directly into the
page cache.

Couple this with a card that makes sure that on a per-page basis, only
data for a particular flow (or group of flows) will accumulate.

People already make cards that can do stuff like this, it can be done
statelessly with an on-chip dynamically maintained flow table.

And best yet it doesn't turn off every feature in the networking nor
bypass it for the actual protocol processing.

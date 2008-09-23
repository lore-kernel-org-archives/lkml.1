Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYIWVwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYIWVwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYIWVwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:52:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58177
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752505AbYIWVwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:52:09 -0400
Date: Tue, 23 Sep 2008 14:51:57 -0700 (PDT)
Message-Id: <20080923.145157.136491514.davem@davemloft.net>
To: cfriesen@nortel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com, steffen.klassert@secunet.com
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
From: David Miller <davem@davemloft.net>
In-Reply-To: <48D92174.5010902@nortel.com>
References: <48D80C9C.2070108@nortel.com>
	<20080922.151233.229805934.davem@davemloft.net>
	<48D92174.5010902@nortel.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chris Friesen" <cfriesen@nortel.com>
Date: Tue, 23 Sep 2008 11:03:48 -0600

> That patch basically just picks an arbitrary cpu for each flow.
> This would spread the load out across cpus, but it doesn't allow any
> input from userspace.

With hardware RX flow seperation, the same exact thing happens.

> We have a current application where there are 16 cores and 16
> threads. They would really like to be able to pin one thread to each
> core and tell the kernel what packets they're interested in so that
> the kernel can process those packets on that core to gain the
> maximum caching benefit as well as reduce reordering issues.  In our
> case the hardware supports filtering for multiqueues, so we could
> pass this information down to the hardware to avoid software
> filtering.
>
> Either way, it requires some way for userspace to indicate interest
> in a particular flow.  Has anyone given any thought to what an API
> like this would look like?

Many cards cannot configure this, but yes we should allow an interface to configure
RX flow seperation preferences, and we do plan on adding that at some point.

It's probably be an ethtool operation of some sort.  We already have a minimalistic
RX flow hashing configuration knob, see ETHTOOL_GRXFH and ETHTOOL_SRXFH.

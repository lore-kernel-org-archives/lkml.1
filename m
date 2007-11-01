Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbXKASHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbXKASHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbXKASGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:06:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:20510 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbXKASGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:06:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,359,1188802800"; 
   d="scan'208";a="193409843"
Message-ID: <472A1526.8070208@intel.com>
Date: Thu, 01 Nov 2007 11:04:22 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jeff@garzik.org, netdev@vger.kernel.org, davej@redhat.com, ajax@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000, e1000e valid-addr fixes
References: <471E99E8.6030404@garzik.org>	<20071023.180744.115914004.davem@davemloft.net>	<471EABEE.8030900@garzik.org> <20071023.192313.115635750.davem@davemloft.net>
In-Reply-To: <20071023.192313.115635750.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2007 18:04:44.0740 (UTC) FILETIME=[AECB3040:01C81CB1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Tue, 23 Oct 2007 22:20:30 -0400
> 
>> David Miller wrote:
>>> From: Jeff Garzik <jeff@garzik.org>
>>> Date: Tue, 23 Oct 2007 21:03:36 -0400
>>>
>>>> I'm wondering if there is a way to avoid adding
>>>>
>>>> 	if (!is_valid_ether_addr(dev->dev_addr))
>>>> 		return -EINVAL;
>>>>
>>>> to every ethernet driver's ->open() hook.
>>> The first idea I get is:
>>>
>>> 1) Create netdev->validate_dev_addr().
>>>
>>> 2) If it exists, invoke it before ->open(), abort
>>>    and return if any errors signaled.
>>>
>>> etherdev init hooks up a function that does the above
>>> check, which allows us to avoid editing every ethernet
>>> driver
>>>
>>> What do you think?
>> Seems sane to me.  Something like this (attached)?
> 
> Looks great:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

I like it.

Should I start sending patches to remove the checks from e1000/e1000e/ixgb/ixgbe
already (to David, I assume?)?

Auke

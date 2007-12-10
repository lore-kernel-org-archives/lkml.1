Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbXLJQGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbXLJQGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXLJQGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:06:04 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:53718 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXLJQGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:06:03 -0500
Message-ID: <475D63DB.5000809@nortel.com>
Date: Mon, 10 Dec 2007 10:05:47 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: andi@firstfloor.org, renzo@cs.unibo.it, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
References: <47585D66.3000404@nortel.com> <20071206.194131.79623068.davem@davemloft.net> <4758CA53.7000407@nortel.com> <20071206.224005.42816421.davem@davemloft.net>
In-Reply-To: <20071206.224005.42816421.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2007 16:05:51.0339 (UTC) FILETIME=[8910D3B0:01C83B46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> The kernel supports much more than 32 groups, see nlk->groups which is
> a bitmap which can be sized to arbitrary sizes.  nlk->nl_groups is
> for backwards compatability only.
> 
> netlink_change_ngroups() does the bitmap resizing when necessary.

Thanks for the explanation.  Given that it's a bitmap doesn't that 
result in a cost of O(number of groups) when processing messages?  In 
our case we need potentially thousands of groups.

> The root multicast listening restriction can be relaxed in some
> circumstances, whatever is needed to fill your needs.

Also, good to know.

> Stop making excuses, with minor adjustments we have the facilities to
> meet your needs.  There is no need for yet-another-protocol to do what
> you're trying to do, we already have too much duplicated
> functionality.

You may have confused me with the OP...I just chimed in because of some 
of the limitations we found when we wanted to do similar things.  In our 
case we created a new unix-like protocol to allow multicast, and have 
been using it for a few years.

However, if we could use netlink instead in our next release that would 
be a good thing.  A couple questions:

1) Is it possible to register to receive all netlink messages for a 
particular netlink family?  This is useful for debugging--it allows a 
tcpdump equivalent.

2) Is there any up-to-date netlink programming guide?  I found this one:

http://people.redhat.com/nhorman/papers/netlink.pdf

but it's three years old now.


Thanks,

Chris

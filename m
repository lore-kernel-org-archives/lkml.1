Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbXLGGkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbXLGGkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 01:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbXLGGkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 01:40:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40378
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbXLGGkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 01:40:06 -0500
Date: Thu, 06 Dec 2007 22:40:05 -0800 (PST)
Message-Id: <20071206.224005.42816421.davem@davemloft.net>
To: cfriesen@nortel.com
Cc: andi@firstfloor.org, renzo@cs.unibo.it, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4758CA53.7000407@nortel.com>
References: <47585D66.3000404@nortel.com>
	<20071206.194131.79623068.davem@davemloft.net>
	<4758CA53.7000407@nortel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chris Friesen" <cfriesen@nortel.com>
Date: Thu, 06 Dec 2007 22:21:39 -0600

> David Miller wrote:
> > From: "Chris Friesen" <cfriesen@nortel.com>
> > Date: Thu, 06 Dec 2007 14:36:54 -0600
> > 
> > 
> >>One problem we ran into was that there are only 32 multicast groups per 
> >>netlink protocol family.
> > 
> > 
> > I'm pretty sure we've removed this limitation.
> 
> As of 2.6.23 nl_groups is a 32-bit bitmask with one bit per group. 
> Also, it appears that only root is allowed to use multicast netlink.

The kernel supports much more than 32 groups, see nlk->groups which is
a bitmap which can be sized to arbitrary sizes.  nlk->nl_groups is
for backwards compatability only.

netlink_change_ngroups() does the bitmap resizing when necessary.

The root multicast listening restriction can be relaxed in some
circumstances, whatever is needed to fill your needs.

Stop making excuses, with minor adjustments we have the facilities to
meet your needs.  There is no need for yet-another-protocol to do what
you're trying to do, we already have too much duplicated
functionality.

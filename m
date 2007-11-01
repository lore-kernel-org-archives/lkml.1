Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbXKAEug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbXKAEug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 00:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbXKAEu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 00:50:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43393
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbXKAEu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 00:50:26 -0400
Date: Wed, 31 Oct 2007 21:50:25 -0700 (PDT)
Message-Id: <20071031.215025.195350296.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: greearb@candelatech.com, djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bguo@sw.starentnetworks.com
Subject: Re: expected behavior of PF_PACKET on NETIF_F_HW_VLAN_RX device?
From: David Miller <davem@davemloft.net>
In-Reply-To: <47292A99.5070805@linux-foundation.org>
References: <20071031123359.3954befc@freepuppy.rosehill>
	<4729269A.6090606@candelatech.com>
	<47292A99.5070805@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Wed, 31 Oct 2007 18:23:37 -0700

> The code in AF_PACKET should fix the skb before passing to user
> space so that there is no difference between accel and non-accel
> hardware.  Internal choices shouldn't leak to user space.  Ditto,
> the receive checksum offload should be fixed up as well.

The hardware has stripped the VLAN header completely and has not
provided it to us at all.

In my opinion trying to cobble one up by hand using the known TAG is
worse than not providing a VLAN header at all.

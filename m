Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZDEAGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZDEAGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 20:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbZDEAFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 20:05:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40438
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754593AbZDEAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 20:05:50 -0400
Date: Sat, 04 Apr 2009 17:05:39 -0700 (PDT)
Message-Id: <20090404.170539.148727646.davem@davemloft.net>
To: amluto@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Tell linkwatch about new interfaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <cb0375e10904010840n1543a890w9039465d0f80ffcc@mail.gmail.com>
References: <cb0375e10904010840n1543a890w9039465d0f80ffcc@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lutomirski <amluto@gmail.com>
Date: Wed, 1 Apr 2009 11:40:06 -0400

> When a network driver registers a new interface, linkwatch will not notice,
> and hence not set the rfc2863 operstate, until netif_carrier_on gets called.
> If the new interface has no carrier when it is connected, then a status of
> "unknown" is reported to userspace, which confuses various tools
> (NetworkManager, for example).
> 
> This fires a linkwatch event for all new interfaces, so that operstate
> gets set reasonably quickly.
> 
> Signed-off-by: Andrew Lutomirski <amluto@gmail.com>

The default assumed state for a freshly registered network
device is that the link is up.

If that disagrees from reality, the driver should make the
appropriate netif_carrier_off() call.

I'm sure you'll find that the e1000 driver is not doing this
and that is what causes the bug you are seeing.

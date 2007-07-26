Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbXGZAMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbXGZAMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXGZAMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:12:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41764
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbXGZAME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:12:04 -0400
Date: Wed, 25 Jul 2007 17:12:03 -0700 (PDT)
Message-Id: <20070725.171203.102545287.davem@davemloft.net>
To: djohnson+linux-kernel@sw.starentnetworks.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       lksctp-developers@lists.sourceforge.net, sakkiped@starentnetworks.com
Subject: Re: [PATCH] IPv6: ipv6_addr_type() doesn't know about RFC4193
 addresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <18087.57717.495366.413571@zeus.sw.starentnetworks.com>
References: <18087.57717.495366.413571@zeus.sw.starentnetworks.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Date: Wed, 25 Jul 2007 19:49:09 -0400

> 
> ipv6_addr_type() doesn't check for 'Unique Local IPv6 Unicast
> Addresses' (RFC4193) and returns IPV6_ADDR_RESERVED for that range.
> 
> SCTP uses this function and will fail bind() and connect() calls that
> use RFC4193 addresses, SCTP will also ignore inbound connections from
> RFC4193 addresses if listening on IPV6_ADDR_ANY.
> 
> There may be other users of ipv6_addr_type() that could also have
> problems.

Contrarily, there may be ipv6_addr_type() call sites that really
do want to reject rfc4193 addresses.

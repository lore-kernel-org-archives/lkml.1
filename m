Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbZD0MnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbZD0MnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZD0MnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:43:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41760
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752999AbZD0MnF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:43:05 -0400
Date: Mon, 27 Apr 2009 05:42:58 -0700 (PDT)
Message-Id: <20090427.054258.16622932.davem@davemloft.net>
To: rbrito@ime.usp.br
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] powerpc: convert mace to netdev_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090427121633.GA29608@ime.usp.br>
References: <20090426155708.GA23159@ime.usp.br>
	<20090426.230648.254087966.davem@davemloft.net>
	<20090427121633.GA29608@ime.usp.br>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rogério Brito <rbrito@ime.usp.br>
Date: Mon, 27 Apr 2009 09:16:33 -0300

> Is this anything close to what needs to be done? It's not without
> failures, because the function mace_set_timeout receives a pointer to a
> struct net_device, but is marked inline and is used by mace_tx_timeout,
> which receives an unsigned long (which calls mace_set_timeout).
> 
> Perhaps it would be a case of removing the inline hint to the compiler?
> I guess that BenH or Paul could comment here better...
> 
> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>

You can fix the mace_set_timeout() function arguments by having
a helper function that simply wraps around it and provides the
second expection of argument types.

Your patch is also wrong, it's missing a lot of netdev_ops
entries that are implicitly obtained via alloc_etherdev(),
namely:

	.ndo_change_mtu		= eth_change_mtu,
	.ndo_set_mac_address 	= eth_mac_addr,
	.ndo_validate_addr	= eth_validate_addr,


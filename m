Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZD0OVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZD0OVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbZD0OVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:21:09 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:33199 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbZD0OVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:21:08 -0400
Date: Mon, 27 Apr 2009 11:20:25 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] powerpc: convert mace to netdev_ops
Message-ID: <20090427142024.GC29608@ime.usp.br>
References: <20090426155708.GA23159@ime.usp.br> <20090426.230648.254087966.davem@davemloft.net> <20090427121633.GA29608@ime.usp.br> <20090427.054258.16622932.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090427.054258.16622932.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dave.

On Apr 27 2009, David Miller wrote:
> You can fix the mace_set_timeout() function arguments by having a
> helper function that simply wraps around it and provides the second
> expection of argument types.

Hummm, this means that I'm not that bad... The wrapper function was the
first thing that came to my mind, but I just wanted to be as least
disruptive as possible.

> Your patch is also wrong, it's missing a lot of netdev_ops
> entries that are implicitly obtained via alloc_etherdev(),
> namely:

Thanks for pointing those out. I didn't find the documentation about
netdev_ops under Documentation (a simple grep didn't turn any results).

> 	.ndo_change_mtu		= eth_change_mtu,
> 	.ndo_set_mac_address 	= eth_mac_addr,
> 	.ndo_validate_addr	= eth_validate_addr,

Nice. I will incorporate such things.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

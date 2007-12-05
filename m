Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbXLESlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbXLESlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 13:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXLESlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 13:41:06 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:19459 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXLESlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 13:41:05 -0500
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: kR2YrGeU3i5IZ7e/KoXXySNh16uouyfpvuAE9NRyohxnu02NkfMqoFqI5zXqM8wH
From: Stefan Rompf <stefan@loplof.de>
To: David Miller <davem@davemloft.net>
Subject: Re: sockets affected by IPsec always block (2.6.23)
Date: Wed, 5 Dec 2007 19:42:31 +0100
User-Agent: KMail/1.9.5
Cc: herbert@gondor.apana.org.au, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20071205001230.GA11391@gondor.apana.org.au> <20071205065132.GA11476@gondor.apana.org.au> <20071204.231200.117152338.davem@davemloft.net>
In-Reply-To: <20071204.231200.117152338.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712051942.32264.stefan@loplof.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 5. Dezember 2007 08:12 schrieb David Miller:

> Actually, consider even a case like DNS.  Let's say the timeout
> is set to 2 seconds or something and you have 3 DNS servers
> listed, on different IPSEC destinations, in your resolv.conf
>
> Each IPSEC route that isn't currently resolved will cause packet loss
> of the DNS lookup request with xfrm_larval_drop set to '1'.
>
> If all 3 need to be resolved, the DNS lookup will fully fail
> which defeats the purpose of listing 3 servers for redundancy
> don't you think? :-)

In your example, the DNS server might actually stop responding to other 
clients while waiting for the (expected to be non-blocking) connect() to 
return. This is much much worse.

Stefan

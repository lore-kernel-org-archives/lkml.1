Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbYIUJOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbYIUJOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 05:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYIUJNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 05:13:54 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:41156 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbYIUJNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 05:13:53 -0400
Message-ID: <48D6104B.9040304@superbug.co.uk>
Date: Sun, 21 Sep 2008 10:13:47 +0100
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: David Miller <davem@davemloft.net>, dwalker@mvista.com,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com,
       steffen.klassert@secunet.com
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
References: <E1KhI4n-0002Fk-7C@gondolin.me.apana.org.au>
In-Reply-To: <E1KhI4n-0002Fk-7C@gondolin.me.apana.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> David Miller <davem@davemloft.net> wrote:
>> receive using multiple RX queues and MSI-X interrupts.  It's
>> also for things like IPSEC where the per-packet cpu usage
>> is so huge (to do the crypto) that it makes sense to even
>> split up the work to multiple cpus within the same flow.
> 
> Unfortunately doing this with IPsec is going to be non-trivial
> since we still want to maintain packet ordering inside IPsec
> and you don't get the inner flow information until you decrypt
> the packet.
> 

Why do you have to preserve packet ordering?
TCP/IP does not preserve packet ordering across the network.
IPSEC uses a sliding window for anti-relay detection precisely because
it has to be able to handle out-of-order packets.

Sharing the sliding window between CPUs might be interesting!

James

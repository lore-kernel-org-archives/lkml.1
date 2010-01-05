Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384Ab0AET1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0AET1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019Ab0AET1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:27:47 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:32788 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab0AET1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:27:47 -0500
Message-ID: <4B439299.1090205@gmail.com>
Date: Tue, 05 Jan 2010 20:27:21 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] net: packet: option to only pass skb protocol
References: <20100105185732.GA30346@redhat.com>
In-Reply-To: <20100105185732.GA30346@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 05 Jan 2010 20:27:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 05/01/2010 19:57, Michael S. Tsirkin a écrit :
> When sending packets with a packet socket it is often necessary to set
> protocol in msg_name: otherwise the protocol field in the skb will not
> be set correctly.  However, currently doing this also requires
> supplying the interface index.
> 
> The following patch makes it possible to avoid supplying the interface
> index by interpreting index 0 as "use device this socket is bound to".
> 

Patch is correct, but I dont understand why zero initialization by caller
is any better then supplying ifindex (known when socket was bound to device ?)

To avoid one syscall at socket setup (to get ifindex from dev name),
you prefer to add a test/branch at each send() syscall...

Am I missing something ?

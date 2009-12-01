Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZLARbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZLARbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZLARbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:31:16 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:54724 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZLARbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:31:15 -0500
Message-ID: <4B155252.1040604@nortel.com>
Date: Tue, 01 Dec 2009 11:28:50 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: seeing strange values for tcp sk_rmem_alloc
References: <4B15416A.2060202@nortel.com> <4B154B29.1030807@cosmosbay.com>
In-Reply-To: <4B154B29.1030807@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Dec 2009 17:31:11.0211 (UTC) FILETIME=[12FECBB0:01CA72AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 10:58 AM, Eric Dumazet wrote:

> Me wondering why you think sk_rmem_alloc is about TX side.
> Its used in RX path. rmem means ReadMemory.

Yep, I realize this.

> You can send 1 Gbytes of data, and sk_rmem_alloc doesnt change, if your
> TCP stream is unidirectionnal.
> 
> sk_rmem_alloc grows when skb are queued into receive queue
> sk_rmem_alloc shrinks when application reads this receive queue.

I realize this.  I sent the data from a socket to itself.  It could just
as easily be done with two tcp sockets.  The important thing is that I
control both the tx and rx sides, so I know how much data should be
present in the rx queue at any point in time.

The part that surprised me was that I could send multiple chunks of data
without sk_rmem_alloc changing on the socket to which the data was being
sent.  Then it would jump up by a large amount (up to 20K) all at once.

I'm starting to suspect that the discrepency might have something to do
with the skb_copy_datagram_iovec() call in tcp_data_queue(), and how
skb_set_owner_r() is only called if "eaten" is <= 0.  This could be
totally off-base though.

Chris

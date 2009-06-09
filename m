Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbZFILB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbZFILB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758371AbZFILBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:01:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46551
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757710AbZFILBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:01:13 -0400
Date: Tue, 09 Jun 2009 04:01:14 -0700 (PDT)
Message-Id: <20090609.040114.256650768.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: netdev@vger.kernel.org, mjt@tls.msk.ru, linux-kernel@vger.kernel.org,
       romieu@fr.zoreil.com
Subject: Re: [patch] r8169: fix crash when large packets are received
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A2D8B8B.80905@gmail.com>
References: <4A2D8B8B.80905@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 09 Jun 2009 00:07:07 +0200

> Michael Tokarev reported receiving a large packet could crash
> a machine with RTL8169 NIC.
> ( original thread at http://lkml.org/lkml/2009/6/8/192 )
> 
> Problem is this driver tells that NIC frames up to 16383 bytes
> can be received but provides skb to rx ring allocated with
> smaller sizes (1536 bytes in case standard 1500 bytes MTU is used)
> 
> When a frame larger than what was allocated by driver is received,
> dma transfert can occurs past the end of buffer and corrupt
> kernel memory.
> 
> Fix is to tell to NIC what is the maximum size a frame can be.
> 
> This bug is very old, (before git introduction, linux-2.6.10), and 
> should be backported to stable versions.
> 
> Reported-by: Michael Tokarev <mjt@tls.msk.ru>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Tested-by: Michael Tokarev <mjt@tls.msk.ru>

Applied to net-2.6, thanks Eric.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0BASKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:10:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589Ab0BASKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:10:18 -0500
Date: Mon, 1 Feb 2010 10:08:51 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Michael Breuer <mbreuer@majjas.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: [PATCH] sky2:  receive dma mapping error handling
Message-ID: <20100201100851.01ac0b5f@nehalam>
In-Reply-To: <20100131221835.GA3317@del.dom.local>
References: <20100128223447.GC3109@del.dom.local>
	<4B621316.8070308@majjas.com>
	<20100128225621.GD3109@del.dom.local>
	<4B6216B9.1010802@majjas.com>
	<20100128153643.0fca3c51@nehalam>
	<4B645EF4.4050701@majjas.com>
	<20100131003449.GA11935@del.dom.local>
	<4B650D53.2010607@majjas.com>
	<4B65D0F9.2020602@majjas.com>
	<4B65FD12.7090101@majjas.com>
	<20100131221835.GA3317@del.dom.local>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jan 2010 23:18:35 +0100
Jarek Poplawski <jarkao2@gmail.com> wrote:

> @@ -1025,9 +1025,10 @@ static void sky2_prefetch_init(struct sky2_hw *hw, u32 qaddr,
>  static inline struct sky2_tx_le *get_tx_le(struct sky2_port *sky2, u16 *slot)
>  {
>  	struct sky2_tx_le *le = sky2->tx_le + *slot;
> -	struct tx_ring_info *re = sky2->tx_ring + *slot;
> +	struct tx_ring_info *re;
>  
>  	*slot = RING_NEXT(*slot, sky2->tx_ring_size);
> +	re = sky2->tx_ring + *slot;
>  	re->flags = 0;

Bogus, le and re are 1-to-1, so hardware portion an software
portion should be at same index.

-- 

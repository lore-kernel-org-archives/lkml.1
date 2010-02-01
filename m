Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0BAWaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:30:00 -0500
Received: from mail.vyatta.com ([76.74.103.46]:45320 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab0BAW37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:29:59 -0500
Date: Mon, 1 Feb 2010 14:29:42 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Michael Breuer <mbreuer@majjas.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: [PATCH v3] sky2:  receive dma mapping error handling
Message-ID: <20100201142942.710273cf@nehalam>
In-Reply-To: <20100201212740.GA3289@del.dom.local>
References: <20100128225621.GD3109@del.dom.local>
	<4B6216B9.1010802@majjas.com>
	<20100128153643.0fca3c51@nehalam>
	<4B645EF4.4050701@majjas.com>
	<20100131003449.GA11935@del.dom.local>
	<4B650D53.2010607@majjas.com>
	<4B65D0F9.2020602@majjas.com>
	<4B65FD12.7090101@majjas.com>
	<20100131221835.GA3317@del.dom.local>
	<20100201102018.7b597992@nehalam>
	<20100201212740.GA3289@del.dom.local>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010 22:27:41 +0100
Jarek Poplawski <jarkao2@gmail.com> wrote:

> @@ -1038,13 +1035,14 @@ static void tx_init(struct sky2_port *sky2)
>  {
>  	struct sky2_tx_le *le;
>  
> -	sky2->tx_prod = sky2->tx_cons = 0;
> +	sky2->tx_prod = 0;
>  	sky2->tx_tcpsum = 0;
>  	sky2->tx_last_mss = 0;
>  
>  	le = get_tx_le(sky2, &sky2->tx_prod);
>  	le->addr = 0;
>  	le->opcode = OP_ADDR64 | HW_OWNER;
> +	sky2->tx_cons = sky2->tx_prod;
>  	sky2->tx_last_upper = 0;
>  }

Your change causes the initial element to be skipped. I want
it to goto the hardware. It makes sure the upper bits of the
first request are set (0).

I don't see what was wrong with my fix.

-- 

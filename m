Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbYFZFq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbYFZFq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 01:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYFZFqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 01:46:20 -0400
Received: from mail.vyatta.com ([216.93.170.194]:50318 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbYFZFqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 01:46:19 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.078
Date: Wed, 25 Jun 2008 22:46:11 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jie Yang <Jie.Yang@Atheros.com>
Cc: "jeff@garzik.org" <jeff@garzik.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2.6.25.3 5/5] atl1e: Atheros L1E Gigabit Ethernet driver
Message-ID: <20080625224611.49022dba@extreme>
In-Reply-To: <72981EBCFD196144B7C6999B9FC34A9A3EE603B868@SHEXMB-01.global.atheros.com>
References: <72981EBCFD196144B7C6999B9FC34A9A3EE603B868@SHEXMB-01.global.atheros.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 13:38:17 +0800
Jie Yang <Jie.Yang@Atheros.com> wrote:

> From: Jie Yang <jie.yang@atheros.com>
> 
> Full patch for the Atheros L1E Gigabit Ethernet driver.
> Supportring AR8121, AR8113 and AR8114
> 
> Signed-off-by: Jie Yang <jie.yang @atheros.com>

> +#define AT_MII_LOCK(_adapter)                          \
> +       do {                                            \
> +               spin_lock(&(_adapter)->mdio_lock);      \
> +       } while (0)
> +
> +#define AT_MII_UNLOCK(_adapter)                                \
> +       do {                                            \
> +               spin_unlock(&(_adapter)->mdio_lock);    \
> +       } while (0)
> +
> +#define AT_MII_LOCK_IRQSAVE(_adapter, _flags)                          \
> +       do {                                                            \
> +               spin_lock_irqsave(&(_adapter)->mdio_lock, (_flags));    \
> +       } while (0)
> +
> +#define AT_MII_UNLOCK_IRQRESTORE(_adapter, _flags)                      \
> +       do {                                                             \
> +               spin_unlock_irqrestore(&(_adapter)->mdio_lock, (_flags));\
> +       } while (0)
> +

Please don't obfuscate (ie wrap) locking primitives. It makes it harder
for humans to evaluate the locking.

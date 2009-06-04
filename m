Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZFDESb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZFDESb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 00:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbZFDESX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 00:18:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48454
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724AbZFDESW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 00:18:22 -0400
Date: Wed, 03 Jun 2009 21:18:23 -0700 (PDT)
Message-Id: <20090603.211823.192890836.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: macro@linux-mips.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] serial: off by one
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A270541.4050900@gmail.com>
References: <4A270541.4050900@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Thu, 04 Jun 2009 01:20:33 +0200

> In zs_console_putchar() occurs:
> 
> 	if (zs_transmit_drain(zport, irq))
> 		write_zsdata(zport, ch);
> 
> However if in zs_transmit_drain() no empty Tx Buffer occurs, limit reaches
> -1 => true, and the write still occurs.
> 
> This patch changes postfix to prefix decrements in this and similar
> functions to prevent similar mistakes in the future. This decreases the
> iterations with one but the chosen loop count was arbitrary anyway.
> 
> In sunhv limit reaches -1, not 0, so the test is off by one.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458Ab0ARDbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0ARDbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 22:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356Ab0ARDbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 22:31:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41979
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039Ab0ARDba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 22:31:30 -0500
Date: Sun, 17 Jan 2010 19:31:40 -0800 (PST)
Message-Id: <20100117.193140.153138395.davem@davemloft.net>
To: julia@diku.dk
Cc: ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/9] drivers/net: Eliminate useless code
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1001161657400.28745@ask.diku.dk>
References: <Pine.LNX.4.64.1001161657400.28745@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat, 16 Jan 2010 16:57:56 +0100 (CET)

> The variable qdev is initialized twice to the same (side effect-free)
> expression.  Drop one initialization.
> 
> A simplified version of the semantic match that finds this problem is:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @forall@
> idexpression *x;
> identifier f!=ERR_PTR;
> @@
> 
> x = f(...)
> ... when != x
> (
> x = f(...,<+...x...+>,...)
> |
> * x = f(...)
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Something in your patch creation process is corrupting these
patches.

> diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
> index f922294..4ef0afb 100644
> --- a/drivers/net/qla3xxx.c
> +++ b/drivers/net/qla3xxx.c
> @@ -4087,9 +4087,8 @@ static void __devexit ql3xxx_remove(struct pci_dev *pdev)
>  	struct ql3_adapter *qdev = netdev_priv(ndev);
>  
>  	unregister_netdev(ndev);
> -	qdev = netdev_priv(ndev);
>  
>  	ql_disable_interrupts(qdev);
>  
> --

That hunk header states that after the line is removed there should
be 8 lines present in the hunk, but the patch only shows 7 such
lines.

I suspect something is eating the final line of your patches.

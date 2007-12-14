Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbXLNT3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbXLNT3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbXLNTYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:24:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53088
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755654AbXLNTYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:24:12 -0500
Date: Fri, 14 Dec 2007 11:23:56 -0800 (PST)
Message-Id: <20071214.112356.16892769.davem@davemloft.net>
To: lyxmoo@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AS apple talk protocol register_snap_client failed
From: David Miller <davem@davemloft.net>
In-Reply-To: <ae65fe130712132203u6d77cf3h9d0265bb37da9574@mail.gmail.com>
References: <ae65fe130712132203u6d77cf3h9d0265bb37da9574@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "guanxun mu" <lyxmoo@gmail.com>
Date: Fri, 14 Dec 2007 14:03:05 +0800

> [PACTH APPLETALK]
> 
> This patch update proto_init process when register_snap_client failed
> 
> Signed-off-by: Michale Moore <lyxmoo@gmail.com>
> 
> diff --git a/net/appletalk/aarp.c b/net/appletalk/aarp.c
> index 6c5c6dc..d6573f6 100644
> --- a/net/appletalk/aarp.c
> +++ b/net/appletalk/aarp.c
> @@ -873,7 +873,10 @@ void __init aarp_proto_init(void)
>  {
>         aarp_dl = register_snap_client(aarp_snap_id, aarp_rcv);
>         if (!aarp_dl)
> -               printk(KERN_CRIT "Unable to register AARP with SNAP.\n");
> +       {
> +               printk(KERN_CRIT "Unable to register AARP with SNAP.\n");
> +               return;
> +       }
>         init_timer(&aarp_timer);
>         aarp_timer.function = aarp_expire_timeout;
>         aarp_timer.data     = 0;

Wrong coding style, the openning brace should be on the same line
as the if() check, see Documentation/CodingStyle   Your email
client has also corrupted the tab characters into spaces, making
the patch unusable even if it were correct.

Next, if you are going to do this, you should modify aarp_proto_init()
to return error values, so that atalk_init() can see it and thus
undo the initialization it does and return an error for the module
load.

It is not useful to add error checks, without propagating them,
because an OOPS is just as good as a partially-initialized protocol
since that is likely to crash or malfunction as well.

The protocol is thus equally broken before and after your changes.

Please completely implement this fix, thank you.

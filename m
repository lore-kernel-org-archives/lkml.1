Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248Ab0A0L4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0A0L4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934Ab0A0L4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:56:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47621
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab0A0L4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:56:23 -0500
Date: Wed, 27 Jan 2010 03:56:35 -0800 (PST)
Message-Id: <20100127.035635.173712880.davem@davemloft.net>
To: anton.ivanov@kot-begemot.co.uk
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: CBQ broken in 2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <1264590347.29501.11.camel@tranquility.sigsegv.cx>
References: <1264590347.29501.11.camel@tranquility.sigsegv.cx>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
Date: Wed, 27 Jan 2010 11:05:47 +0000

> I have been looking at CBQ being broken in 2.6 (Debian BUG 534430).

Please direct your question to netdev@vger.kernel.org which is
where the networking experts hang out.

Added to CC:

> The bug is very simple and it makes it unusable for all practical
> purposes - BOUNDED classes always borrow from their parent. As a result
> it impossible to:
> 
> 1. Set and enforce a bandwidth limit to a class with a CBQ tree
> 2. Use CBQ to do QoS at any place but the actual link. For example - put
> a linux box after behind a DSL modem and tell it to QoS at the bandwidth
> at which the modem is configured.
> 
> I have now looked through the code of cbq_sched.c (in 2.6.33-rc5 and
> 2.6.26 as shipped by Debian).

I think you mean net/sched/sch_cbq.c, there is no cbq_sched.c
anywhere in the source tree.

> In both pieces of code the variable in the class structure for CBQ
> cl->borrow is used to signal if borrowing is allowed. If borrowing is
> not allowed (BOUNDED class) it is set to NULL.
> 
> However the routine which parses the class options and defines the class
> cbq_change_class() sets it to the parent class and never resets it to
> NULL for bounded classes.
> 
> Am I missing something here? 
> 
> Please cc me as I am not subscribed to the list.
> 
> Best Regards,
> 
> -- 
>    Understanding is a three-edged sword:
>             your side, their side, and the truth. --Kosh Naranek
> 
> A. R. Ivanov
> E-mail:  anton.ivanov@kot-begemot.co.uk
> WWW:     http://www.kot-begemot.co.uk/
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

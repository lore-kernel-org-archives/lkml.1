Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbXJGQz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbXJGQz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbXJGQzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:55:47 -0400
Received: from ev1s-75-125-39-150.ev1servers.net ([75.125.39.150]:38768 "EHLO
	colorfullife.mysite.adiungo.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbXJGQzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:55:46 -0400
Message-ID: <47090F55.3020800@colorfullife.com>
Date: Sun, 07 Oct 2007 18:54:45 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       nedev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: MSI interrupts and disable_irq
References: <46FC15A9.1070803@nvidia.com> <46FDBCB4.9090802@pobox.com> <86802c440710061043u6e51cd7q468346bd06b08657@mail.gmail.com> <4707CCF1.8080909@pobox.com>
In-Reply-To: <4707CCF1.8080909@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>
> Interested parties should try the forcedeth patches I just posted :)
>
The patches look good, but I would still prefer to understand why the 
current implementation causes crashes before rewriting everything.

I've just noticed that netpoll_send_skb() calls ->hard_start_xmit() and 
->poll() within local_irq_save().
Thus it seems that  spin_lock_irqsave() must be used in the poll() and 
hard_start_xmit() callbacks, at least in nics that support 
POLL_CONTROLLER :-(

--
    Manfred


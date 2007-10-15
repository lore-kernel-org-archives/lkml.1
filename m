Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbXJOT5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbXJOT5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932605AbXJOT52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:57:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46177
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932924AbXJOT50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:57:26 -0400
Date: Mon, 15 Oct 2007 12:57:31 -0700 (PDT)
Message-Id: <20071015.125731.79447899.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       shemminger@linux-foundation.org
Subject: Re: WARNING: at net/core/dev.c:2161 net_rx_action()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071015112430.GA30006@elte.hu>
References: <20071015112430.GA30006@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 15 Oct 2007 13:24:30 +0200

> got this warning with Linus' latest -git tree:
> 
>   WARNING: at net/core/dev.c:2161 net_rx_action()
>    [<80564db4>] net_rx_action+0xce/0x186
>    [<8011ba98>] __do_softirq+0x6c/0xcf
>    [<8011bb2d>] do_softirq+0x32/0x36
>    [<8011bcae>] irq_exit+0x35/0x40
>    [<80104fdb>] do_IRQ+0x5c/0x71
>    [<801048cd>] do_nmi+0x8f/0x238
>    [<801033a3>] common_interrupt+0x23/0x30
>    =======================

This is a driver bug, the work "budget" passed into a driver's
->poll() handler should never be exceeded.  That's what this
warning assertion is checking.

What ethernet card is in your system and what driver is being
used to drive it?


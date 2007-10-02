Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbXJBUHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbXJBUHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 16:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbXJBUHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 16:07:11 -0400
Received: from ev1s-75-125-39-150.ev1servers.net ([75.125.39.150]:37709 "EHLO
	colorfullife.mysite.adiungo.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbXJBUHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:07:09 -0400
X-Greylist: delayed 3619 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2007 16:07:06 EDT
Message-ID: <47029606.1080104@colorfullife.com>
Date: Tue, 02 Oct 2007 21:03:34 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ayaz Abdulla <aabdulla@nvidia.com>
CC: Jeff Garzik <jgarzik@pobox.com>, nedev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: MSI interrupts and disable_irq
References: <46FC15A9.1070803@nvidia.com>
In-Reply-To: <46FC15A9.1070803@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ayaz Abdulla wrote:
> I am trying to track down a forcedeth driver issue described by bug 
> 9047 in bugzilla (2.6.23-rc7-git1 forcedeth w/ MCP55 oops under heavy 
> load). I added a patch to synchronize the timer handlers so that one 
> handler doesn't accidently enable the IRQ while another timer handler 
> is running (see attachment 'Add timer lock' in bug report) and for 
> other processing protection.
>
> However, the system still had an Oops. So I added a lock around the 
> nv_rx_process_optimized() and the Oops has not happened (see 
> attachment 'New patch for locking' in bug report). This would imply a 
> synchronization issue. However, the only callers of that function are 
> the IRQ handler and the timer handlers (in non-NAPI case). The timer 
> handlers  use disable_irq so that the IRQ handler does not contend 
> with them. It looks as if disable_irq is not working properly.
Either disable_irq() is not working properly or interrupts are nested, 
i.e. the irq handler is called again while running.
Which timer handler do you mean? I only see disable_irq() in the 
configuration paths (set mtu, change ring size, ...) and in the tx 
timeout case.
Neither one should happen during normal operation.

--
    Manfred

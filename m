Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYE0NO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYE0NO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbYE0NOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:14:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47594
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757300AbYE0NOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:14:46 -0400
Date: Tue, 27 May 2008 06:14:42 -0700 (PDT)
Message-Id: <20080527.061442.193726441.davem@davemloft.net>
To: komurojun-mbn@nifty.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PLEASE REVERT] "Add a WARN_ON_ONCE" at
 net/sched/sch_generic.c:
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080527213424.125e15dc.komurojun-mbn@nifty.com>
References: <20080525112308.03a5fda7.komurojun-mbn@nifty.com>
	<20080525.051032.186144643.davem@davemloft.net>
	<20080527213424.125e15dc.komurojun-mbn@nifty.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Komuro <komurojun-mbn@nifty.com>
Date: Tue, 27 May 2008 21:34:24 +0900

> I think the transmit timeout indicates 
> that the cable is not connected or the irq is conflict.

The MAC of the chip transmits and ACKs the packet in the hardware even
if the link is down.  The packet is simply dropped.

Also, when the link goes down, the driver should mark the device as
such.  In such a state, the generic networking does not pass new
packets to the driver.

Therefore, transmit timeouts in this case are a hardware
or driver error.

If there is an IRQ issue, that is an error that'd we would like to
have as much information as possible to diagnose.  So the warning is
still entirely appropriate.

I sense that you are seeing this warning triggered, and if so I
would suggest that you investigate it fully as it should not be
happening under normal circumstances.

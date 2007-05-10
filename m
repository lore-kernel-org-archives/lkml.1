Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbXEJARm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbXEJARm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXEJARc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:17:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50605 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447AbXEJARa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:17:30 -0400
Message-ID: <46426498.5050205@garzik.org>
Date: Wed, 09 May 2007 20:17:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       web01@danzon.com
Subject: Re: [PATCH] sata_nv: fix ADMA freeze/thaw/irq_clear issues
References: <463CF8E4.6000902@shaw.ca>
In-Reply-To: <463CF8E4.6000902@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This patch fixes some problems with ADMA-capable controllers with regard 
> to freeze,
> thaw and irq_clear libata callbacks. Freeze and thaw didn't switch the 
> ADMA-specific
> interrupts on or off, and more critically the irq_clear function didn't 
> respect
> the restriction that the notifier clear registers for both ports have to 
> be written
> at the same time even when only one port is being cleared. This could 
> result in
> timeouts on one port when error handling (i.e. as a result of hotplug)
> occurred on the other port.
> 
> As well, this fixes some issues in the interrupt handler: we shouldn't 
> check any
> ADMA status if the port has ADMA switched off because of an ATAPI 
> device, and
> it also checks to see if any ADMA interrupt has been raised even when we 
> are in
> port-register mode.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

applied

please properly word-wrap your patch descriptions in the future



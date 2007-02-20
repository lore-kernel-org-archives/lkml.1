Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXBTPhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXBTPhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965082AbXBTPhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:37:43 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43869 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965052AbXBTPhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:37:42 -0500
Message-ID: <45DB15C2.7020206@garzik.org>
Date: Tue, 20 Feb 2007 10:37:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Tejun Heo <htejun@gmail.com>, auxsvr@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: ata command timeout
References: <200702192119.50954.auxsvr@gmail.com> <45DA7416.4040101@gmail.com> <45DB114B.4020903@rtr.ca>
In-Reply-To: <45DB114B.4020903@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> I don't believe that.  Command timeouts never happen on healthy systems,
> unless we have a driver bug.  Okay, so I can imagine a pathological case
> of a full queue (NCQ) with all 32 commands taking longer than usual due
> to ECC retries in the firmware..

It's not quite so black and white.  There have definitely been interrupt 
delivery problems that cause command timeouts.  Also, Intel PIIX BMDMA 
(all standard PCI IDE, I think?) is defined to /not/ send an interrupt, 
when a DMA error occurs.  The driver is instructed to time out the 
transaction, and start recovery by deducing the state of things from the 
DMA status bits.

Nonetheless, I mostly agree with your statement.  The two most common 
causes of timeouts that I see are interrupt delivery problems, and 
driver bugs.

	Jeff



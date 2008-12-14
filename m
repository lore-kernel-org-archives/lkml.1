Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbYLNSxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbYLNSxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 13:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYLNSxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 13:53:05 -0500
Received: from colo.lackof.org ([198.49.126.79]:55108 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbYLNSxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 13:53:04 -0500
Date: Sun, 14 Dec 2008 11:52:39 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: MSI messages
Message-ID: <20081214185239.GA2039@colo.lackof.org>
References: <49438290.1080502@gmail.com> <20081214081210.GC13371@colo.lackof.org> <4944EAC3.1020407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4944EAC3.1020407@gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 03:15:15PM +0400, Manu Abraham wrote:
...
> > A "GSI" (Generic Sys Interrupt?) is associated with each entry in
> > the MSI-X table. Driver then calls request_irq() to bind an interrupt
> > handler to each GSI. So the driver never directly sees the "message".
> 
> Oh, you mean the array of irq_handlers in the MSI-X table should 
> correspond to a particular message ?

No. I mean each MSI-X entry has an address+message pair and each MSI-X entry
is associated with the parameters passed to each call of request_irq().
Pass in unique private data to each call of request_irq() and the driver
can determine which message was delivered when the ISR gets called.
(ISR == Interrupt Service Routine, aka driver IRQ handler)

> I remember sometime back somebody stated that one might not get 
> the requested number of handlers what you requested. 

Correct. The limit is defined by the number of GSI's available
from the HW.

> In such a case, if the irq_handlers are mapped in a static fashion, one 
> might not get any interrupt callbacks for a specific functionality of 
> the hardware. Or is there something missing in what i understood ?

Correct.

grant

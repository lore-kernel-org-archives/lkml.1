Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbYLNLPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbYLNLPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 06:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYLNLP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 06:15:29 -0500
Received: from mail.work.de ([212.12.32.20]:41769 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbYLNLP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 06:15:28 -0500
Message-ID: <4944EAC3.1020407@gmail.com>
Date: Sun, 14 Dec 2008 15:15:15 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: MSI messages
References: <49438290.1080502@gmail.com> <20081214081210.GC13371@colo.lackof.org>
In-Reply-To: <20081214081210.GC13371@colo.lackof.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Sat, Dec 13, 2008 at 01:38:24PM +0400, Manu Abraham wrote:
>> Hi,
>>
>> I am wondering how to handle this:
>>
>> Does the kernel somehow handle MSI message readback from the PCI config space 
>> for the MSI message as described in 6.8.1 of the PCI Bus specification 2.3 or 
>> does a device specific driver have to read the Message Address and Data ?
>>
>> To put it short: i am wondering how i should read the MSI messages.
> 
> The "message" is actually mapped to an the interrupt vector by the core
> generic interrupt handling code in the kernel.
> 
> A "GSI" (Generic Sys Interrupt?) is associated with each entry in
> the MSI-X table. Driver then calls request_irq() to bind an interrupt
> handler to each GSI. So the driver never directly sees the "message".

Oh, you mean the array of irq_handlers in the MSI-X table should 
correspond to a particular message ?

I remember sometime back somebody stated that one might not get 
the requested number of handlers what you requested. 

In such a case, if the irq_handlers are mapped in a static fashion, one 
might not get any interrupt callbacks for a specific functionality of 
the hardware. Or is there something missing in what i understood ?

Regards,
Manu

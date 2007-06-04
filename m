Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbXFDObU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbXFDObU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXFDObJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:31:09 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:51776 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbXFDObH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:31:07 -0400
Date: Mon, 04 Jun 2007 08:31:05 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: hisax isdn card (Sedlbauer Speed Fax+) does not get an interrupt
In-reply-to: <Pine.LNX.4.63.0706041033140.17261@er-systems.de>
To: Thomas Voegtle <tv@lio96.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <46642229.6070107@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
References: <fa./GDxiXMgfJlsQXnkvKu3TibPJV8@ifi.uio.no>
 <465EDDC0.6090601@shaw.ca> <Pine.LNX.4.63.0706041033140.17261@er-systems.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Voegtle wrote:
> Thx for your answer. Unfortunately, it didn't help us yet in finding a fix 
> for the problem.
> 
> The first IRQs are received after the call to pci_enable_device, but 
> before the IRQ handler itself is registered (register_irq). The IRQs seem 
> to be triggered by the write operations to the card registers 
> (byteout()/outb() calls around lines 676ff in sedlbauer.c); the IRQ 
> handler is registered much later, though. The dump above suggests that the 
> kernel relays the interrupts to the USB handler (on the same IRQ) instead 
> - which obviously is wrong.
> 
> In short:
> * pci_enable_device
> * writing to card registers -> triggering interrupts
>   (handler not yet installed -> error)
> * register interrupt -> fails, as it already was disabled due to the 
>   errors
> 
> Again: thx for your comments. Do you have any further ideas/advice on how 
> to get the driver running?

Presumably whatever writes the driver is doing there are enabling the 
card to generate interrupts - in this case the IRQ handler needs to be 
registered before this point, and not after..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


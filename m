Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbXJ3WXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbXJ3WXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbXJ3WXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:23:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37165 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbXJ3WXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:23:16 -0400
Message-ID: <4727AED2.6010908@garzik.org>
Date: Tue, 30 Oct 2007 18:23:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Shawn Jin <shawnxjin@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Multiple MSI messages support
References: <c3d0340b0710301413r2607ee08x8b27c5bffa43f1c4@mail.gmail.com>
In-Reply-To: <c3d0340b0710301413r2607ee08x8b27c5bffa43f1c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Jin wrote:
> Hi,
> 
> If this is really off-topic here, I apologize first. But I cannot
> think a better place to ask this particular question.
> 
> I understand that the current PCI subsystem or linux kernel (x86)
> supports only one message when MSI is enabled even for devices having
> multiple MSI messages. But why? Is this a limitation solely due to the
> OS or due to the x86 APIC?
> 
> I know the current linux kernel (2.6.23) changed MSI message data
> format a little bit to support other architectures. But some older
> version (e.g. 2.6.18) defined a specific format for the MSI msg data
> in a way that 8 bits contain the irq number and the other 8 bits have
> the interrupt attributes, which is x86 specific. Why does the msg data
> need to contain the irq number? Here is my hypothetic explanation. The
> device writes the MSI msg data to the specified MSI msg address. And
> APIC uses the irq number in the msg data to generate appropriate
> interrupt, which of course results in an appropriate ISR invoked. A
> device having multiple MSI messages typically appends some information
> of which MSI message to the msg data field. For example, if the system
> (or OS) configures the MSI msg data as 0x5000, a device having 4 MSI
> messages could write 0x5000, 0x5001, 0x5002, 0x5003 to differentiate
> the MSI messages. However this cannot work with the APIC due to the
> way how APIC asserts interrupts as I described above (if my
> understanding is correct).
> 
> Hence my answer to the question is this is due to the x86 APIC. For
> other architectures such as powerpc this is probably not a problem
> since the interrupt controller is different. Am I correct?

IMO it's more like there has never been enough need for anybody to look 
into it, I bet...

The way drivers are written, you are typically must touch a few key 
hardware registers _anyway_, so the multiple messages in practice are 
not much more useful than the simple fact that your MSI irq handler 
function was called (with all that indicates and implies).

	Jeff



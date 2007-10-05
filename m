Return-Path: <linux-kernel-owner+w=401wt.eu-S1761923AbXJEMER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761923AbXJEMER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 08:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbXJEMEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 08:04:04 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36155 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755347AbXJEMED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:04:03 -0400
X-Sasl-enc: 5GZ9h90XoLYdJuDiZko8iM4hT3KRXoGszNSwW63vaHuY 1191585841
Mime-Version: 1.0 (Apple Message framework v752.2)
In-Reply-To: <1191513164.25019.1214154783@webmail.messagingengine.com>
References: <1191513164.25019.1214154783@webmail.messagingengine.com>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DD4F5A27-64A9-4A16-B3B0-D825F9A88AAD@bluecamel.eml.cc>
Content-Transfer-Encoding: 7bit
From: Scott <linux-kernel@bluecamel.eml.cc>
Subject: Re: cx88 pci_abort messages
Date: Fri, 5 Oct 2007 08:04:04 -0400
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 4, 2007, at 11:52 AM, Scott wrote:

> I'm having what I think is a PCI bus problem.
>
> I have a ASUS P5B Intel 965 motherboard and a DVICO Fusion HDTV5 RT
> adapter on the PCI bus. When this adapter is recording (anything) I  
> see
> pci_abort messages repeating in the /var/log/messages file. As a  
> result
> I see some minor video corruption during playback. I've installed the
> adapter into a PCI slot that shares an IRQ with the onboard USB.
> However, I've also disabled all USB support in BIOS, so the adapter is
> the only thing on the IRQ, and still see the same errors.
>
> Any suggestions for further troubleshooting? Is this a PCI bus  
> quirk on
> this motherboard? A copy of my .config is at
> http://donpoo.net/kernel_config
>
> Oct  2 21:59:12 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
> Oct  2 21:59:12 htpc cx88[0]/2-mpeg: general errors: 0x00080000
> Oct  2 21:59:20 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
> Oct  2 21:59:20 htpc cx88[0]/2-mpeg: general errors: 0x00080000
> Oct  2 21:59:32 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
> Oct  2 21:59:32 htpc cx88[0]/2-mpeg: general errors: 0x0008000

I was poking around the PCI bus with setpci/lspci last night and  
tried adjusting the latency from 64 to 32. This didn't make a  
difference. I also changed my core2duo speedstep governor from  
ondemand to performance to prevent the CPUs from changing speed. I  
eventualy saw the same pci_abort message but I might have seen less  
of them.

Is there a way to log every device pci device that throws an  
interrupt? I'm thinking if I could find out which pci device was  
stealing the interrupt that I could disable it or look at the code  
and see what it was doing.

--
Scott 

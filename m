Return-Path: <linux-kernel-owner+w=401wt.eu-S932445AbXA1IEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbXA1IEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 03:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932461AbXA1IEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 03:04:55 -0500
Received: from terminus.zytor.com ([192.83.249.54]:49666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445AbXA1IEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 03:04:54 -0500
Message-ID: <45BC5919.8030004@zytor.com>
Date: Sun, 28 Jan 2007 00:04:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andreas Block <andreas.block@esd-electronics.com>
CC: Xavier Bestel <xavier.bestel@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: Bugfixes: PCI devices get assigned redundant IRQs
References: <op.tmrce0km8n9ctc@pc-block.esd> <1169809255.10952.178.camel@frg-rhel40-em64t-03> <op.tmrh5hxp8n9ctc@pc-block.esd>
In-Reply-To: <op.tmrh5hxp8n9ctc@pc-block.esd>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Block wrote:
>>
>> Aren't there platforms for which irq = 0 is a valid irq ?
> 
> As far as I understand the PCI spec, the answer to your question seems 
> to be: no
> (or I'm missing something).
> 
> Don't get me wrong. I'm not talking about system IRQs, but about the 
> value of the Interrupt Pin Register in PCI configuration space.
> 
> The PCI Local Bus Specification in Revision 3.0 from 3rd February 2004 
> says on page 223 about the content of Interrupt Pin register:
> 
> Value 0x00: _No_ interrupt
> Values 0x01 to 0x04: Interrupt lines A to D
> And values 5 to 0xFF are reserved.
> 
> So I'd say, the "correction" of greater values than four to a value of 
> one seems discussable, too. Because it will break any future changes of 
> the PCI spec.
> 

I think you're confusing the Interrupt Line register and the Interrupt 
Pin register.  The Interrupt Line register is platform-dependent, but on 
x86 platforms it generally contains the IRQ number (and IRQ 0 is valid, 
although in practice it is never used since IRQ 0 is the system timer 
and is never connected to the PCI bus), or 255 meaning "none" -- see the 
footnote on page 223 of the PCI 3.0 spec.

	-hpa

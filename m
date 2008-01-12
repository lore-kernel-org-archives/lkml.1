Return-Path: <linux-kernel-owner+w=401wt.eu-S1760367AbYALVj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367AbYALVj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 16:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbYALVjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 16:39:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47487 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbYALVjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 16:39:16 -0500
Message-ID: <47893374.4080102@zytor.com>
Date: Sat, 12 Jan 2008 13:39:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Benjamin LaHaise <bcrl@kvack.org>, akpm@osdl.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: remove "too much work for irq" printk
References: <20080112201543.GB12775@kvack.org> <20080112212457.3bf534af@lxorguk.ukuu.org.uk>
In-Reply-To: <20080112212457.3bf534af@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sat, 12 Jan 2008 15:15:43 -0500
> Benjamin LaHaise <bcrl@kvack.org> wrote:
> 
>> When using kvm with a serial console, the serial driver will print out 
>> "too much work for irq4" on any heavy activity (ie vi on a file repainting 
>> the terminal).  This message is entirely spurious, as output continues to 
>> work fine.  Remove the message as it corrupts screen output and is far too 
>> easy to trigger.
> 
> NAK. This is a qemu/kvm emulation bug. The real check is there to catched
> jammed IRQs and combined with the IRQ bug handling nowdays does actually
> do the intended job.
> 
> Our serial port code (correctly) interprets a continuous stream of bytes
> at an impossible bit rate as an error. KVM should be emulating to some
> extent at least the timing on serial interfaces or using a virtualised
> interface.
> 

This is going to put trouble in other places unless, at least, it can be 
turned off.  The UART serial interface is heavily emulated as a console 
interface without an actual serial port behind it, both in hardware and 
software.  Rates will typically vastly exceed real serial port rates, 
especially emulating 16450 or 16550 (which is typical) which are limited 
to 115200 bps.

	-hpa

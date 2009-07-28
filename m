Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZG1Tbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZG1Tbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbZG1Tbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:31:31 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:47537 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZG1Tba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EjA5Nff+lb8by6nT0clmH8Q9Jf4kFpoXcj+qUDv6z5+mcKAUJu57+LFy0v7dzoZpAc
         WISzGvt0vpvBq7F5mpi2XDpcyT9ZOYbZ6iwl3SLRqK2F+xh7u3t8Fw+BLpTWY8UmLBNE
         OCVkFjJRoh2ynlhVPjLPMqMfWCjQllo3WIp9A=
Message-ID: <4A6F520B.6090202@gmail.com>
Date: Tue, 28 Jul 2009 13:31:23 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux USB <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [2.6.31-rc4] ftdi_usb maps memory from stack...
References: <6278d2220907271517u46894cbu69ae52148664e04e@mail.gmail.com>
In-Reply-To: <6278d2220907271517u46894cbu69ae52148664e04e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2009 04:17 PM, Daniel J Blueman wrote:
> With DMA debugging enabled, I see a warning when the FTDI USB-serial
> driver loads [1] using a non-DMAable address.
>
> I can get a disassembly of some of the stack frames to identify the
> exact call-sites etc, if that helps anyone?
>
> Thanks,
>    Daniel
>
> --- [1]
>
> usbcore: registered new interface driver usbserial_generic
>
> usbserial: USB Serial Driver core
>
> USB Serial support registered for FTDI USB Serial Device
>
> ftdi_sio 5-1:1.0: FTDI USB Serial Device converter detected
>
> usb 5-1: Detected FT8U232AM
>
> usb 5-1: Number of endpoints 2
>
> usb 5-1: Endpoint 1 MaxPacketSize 64
>
> usb 5-1: Endpoint 2 MaxPacketSize 64
>
> usb 5-1: Setting MaxPacketSize 64
>
> ------------[ cut here ]------------
>
> WARNING: at lib/dma-debug.c:856 check_for_stack+0x9a/0xc0()
>
> Hardware name: OEM
>
> uhci_hcd 0000:00:1d.0: DMA-API: device driver maps memory from stack
> [addr=ffff88007f89b946]

Looks like some of the functions in ftdi_sio.c call usb_control_msg with 
a stack buffer and some use a kmalloc buffer. They should likely all be 
using a kmalloc buffer.
